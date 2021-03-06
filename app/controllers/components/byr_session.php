<?php
/**
 * byr session component for nforum 
 * core session
 * 
 * @author xw       
 */
class ByrSessionComponent extends Object {    
    
    public $components = array("Cookie");
    public $isLogin = false;
    public $isGuest = false;
    //is first login
    public $hasCookie = true;
    public $userId = "";
    public $from = "";
    //false when check from pwd
    private $_updateID = true;
    //true when setonline ok
    private $_isSetOnline = false;

    public function initialize(&$controller) {
        $this->controller = $controller;
        $this->Cookie->name = Configure::read("cookie.prefix");
        $this->Cookie->domain = Configure::read("cookie.domain");
        $this->Cookie->path = Configure::read("cookie.path");
    }

    //i don't want to check proxy which ip will be man-made
    public function setFromHost(){
        @$this->from = $_SERVER["REMOTE_ADDR"];
        if(Configure::read('proxy.X_FORWARDED_FOR')){
            @$fullfrom = $_SERVER["HTTP_X_FORWARDED_FOR"];
            if($fullfrom != ""){
                $ips = explode(",", $fullfrom);
                $this->from = array_pop($ips);
            }
        }
        if($this->from == "")
            $this->from = "127.0.0.1";
        //param 2 is unused
        Forum::setFrom($this->from, "");
    }
        
    public function initLogin(){
        @$utmpkey = $this->Cookie->read("UTMPKEY");
        @$utmpnum = $this->Cookie->read("UTMPNUM");
        @$this->userId = $this->Cookie->read("UTMPUSERID");
        @$userpwd = $this->Cookie->read("PASSWORD");
        if(Configure::read("cookie.encryption")){
            $utmpkey = $this->decrypt($utmpkey);
            $userpwd = $this->decrypt($userpwd);
        }

        $arr = array();
        //valid cookie integrity
        if($this->userId == ""){
            $this->_guestLogin();
            $this->hasCookie = false;
        }else if($this->userId == "guest"){
            if($utmpkey != "" && $utmpnum != "" && Forum::initUser($this->userId,intval($utmpnum),intval($utmpkey))){
                $this->isLogin = false;
                $this->isGuest = true;
                $this->_isSetOnline = true;
            }else{
                $this->_guestLogin();
                $this->hasCookie=false;
            }
        }else{
            if(Forum::initUser($this->userId,intval($utmpnum),intval($utmpkey))){
                $this->isLogin = true;    
                $this->_isSetOnline = true;
            }else if($userpwd != "" && Forum::checkPwd($this->userId, base64_decode($userpwd), true, true)){
                $ret = Forum::setUser(true);
                if($ret == 0 || $ret == 2){
                    $this->isLogin = true;
                    $this->_updateID = false;
                }else if($ret == 5){
                    $this->controller->error(ECode::$LOGIN_FREQUENT);
                }
            }
            if(!$this->isLogin)
                $this->_guestLogin();
        }
    }

    public function setCookie(){
        if($this->_isSetOnline)
            return; 
        $u = User::getInstance();
        $arr = array();
        Forum::initUser($this->userId, $u->index, $u->utmpkey);
        $utmpkey = $u->utmpkey;
        if(Configure::read("cookie.encryption")){
            $utmpkey = $this->encrypt($u->utmpkey);
        }
        if($this->_updateID)
            $this->Cookie->write("UTMPUSERID", $u->userid, false);
        $this->Cookie->write("UTMPKEY", $utmpkey, false);
        $this->Cookie->write("UTMPNUM", $u->index, false);
    }

    public function login($id, $pwd, $md5 = true, $cookieTime = null){
        if($this->isLogin || $this->isGuest)
            Forum::kickUser();
        if (($id != 'guest') && (!Forum::checkPwd($id, $pwd, $md5, true))){
            throw new LoginException(ECode::$LOGIN_ERROR);
        }
        $ret = Forum::setUser(true);
        switch($ret){
            case -1:
                throw new LoginException(ECode::$LOGIN_MULLOGIN);
            case 1:
                throw new LoginException(ECode::$LOGIN_MAX);
            case 3:
                throw new LoginException(ECode::$LOGIN_IDBAN);
            case 4:
                throw new LoginException(ECode::$LOGIN_IPBAN);
            case 5:
                throw new LoginException(ECode::$LOGIN_FREQUENT);
            case 7:
                throw new LoginException(ECode::$LOGIN_NOPOS);
        }
        User::update();
        $u = User::getInstance();
        $utmpkey = $u->utmpkey;
        $pass = base64_encode($u->md5passwd);
        if(Configure::read("cookie.encryption")){
            $utmpkey = $this->encrypt($utmpkey);
            $pass = $this->encrypt($pass);
        }
        $this->isLogin = true;
        $this->Cookie->write("UTMPUSERID", $u->userid, false, $cookieTime);
        $this->Cookie->write("UTMPKEY", $utmpkey, false);
        $this->Cookie->write("UTMPNUM", $u->index, false);
        $this->Cookie->write("PASSWORD", $pass, false, $cookieTime);
    }

    public function logout(){
        if($this->isLogin || $this->isGuest)
            Forum::kickUser();
        $time = time() + 36000000;
        $this->isLogin = false;
        $this->Cookie->write("UTMPUSERID", "", false, $time);
        $this->Cookie->write("UTMPKEY", "", false, $time);
        $this->Cookie->write("UTMPNUM", "", false, $time);
        $this->Cookie->write("PASSWORD", "", false, $time);
    }

    public function encrypt($var){
        return urlencode($this->_getKey(strlen($var)) ^ "$var");
    }

    public function decrypt($var){
        return $this->_getKey(strlen(urldecode($var))) ^ urldecode("$var");
    }

    private function _guestLogin(){
        if($this->isGuest)
            return;
        $ret = Forum::setUser(false);
        if($ret == 0 || $ret == 2){
            $this->userId = "guest";
            $this->isLogin = false;
            $this->isGuest = true;
        }
    }

    private function _getKey($len){
        if(!isset($this->from))
            $this->setFromHost();
        $ip = $this->from;
        if(strpos($ip, ':') !== false)
            $ip = join(":", array_slice(explode(':', $ip, 5), 0, 4))."::1";
        $hash = sha1($ip);  
        $key = substr($hash, 4, $len);
        return $key;
    }
}
class LoginException extends Exception{}
?>
