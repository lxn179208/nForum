<?php

class SectionController extends ApiAppController {

    public function index(){
        App::import("vendor", "model/section");
        if(!isset($this->params['name'])){
            $this->error(ECode::$SEC_NOSECTION);
        }
        try{
            $num = $this->params['name'];
            $sec = Section::getInstance($num, Section::$NORMAL);
        }catch(SectionNullException $e){
            $this->error(ECode::$SEC_NOSECTION);
        }catch(BoardNullException $e){
            $this->error(ECode::$BOARD_NOBOARD);
        }

        $wrapper = Wrapper::getInstance();

        $data = array();
        $data = $wrapper->section($sec, array('status' => true));
        $secs = $sec->getAll();

        $ret = false;
        $data['board'] = $data['sub_section'] = array();
        if(!$sec->isNull()){
            foreach($secs as $brd){
                if($brd->isDir())
                    $data['sub_section'][] = $brd->NAME;
                else
                    $data['board'][] = $wrapper->board($brd, array('status'=>true));
            }
        }

        $this->set('data', $data);
    }
}
?>
