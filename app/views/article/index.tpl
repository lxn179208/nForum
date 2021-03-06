    <div class="t-pre">
        <div class="page">
            <ul class="pagination">
			  <li class="page-pre">贴数:<i><{$totalNum}></i>&emsp;分页:</li>
              <li><ol title="分页列表" class="page-main"><{$pageBar}></ol></li>
			  <li class="page-suf"></li>	
            </ul>
        </div>
		<div class="t-btn">
<{if !$tmpl}>
        	<a href="<{$base}>/article/<{$bName}>/post" class="a-post button">新话题</a>
<{/if}>
        	<a href="<{$base}>/article/<{$bName}>/tmpl" class="a-post button">模版发文</a>
            <a href="javascript:void(0)" id="a_reply" class="button">快捷回复</a>
        </div>
    </div>
	<{capture name=n_left}>文章主题:&ensp;<{$title}><{/capture}>
	<{capture name=n_right}><span style="color:#eee;vertical-align:bottom" id="a_share" _u="<{$domain}><{$base}>/article/<{$bName}>/<{$gid}>" _c="<{$title}>">分享到:</span><{/capture}>
	<{include file="s_nav.tpl" nav_left=$smarty.capture.n_left nav_right=$smarty.capture.n_right}>
    	<div class="b-content corner">
<{foreach from=$info item=item}>
	<a name="a<{$item.pos}>"></a>
    <div class="a-wrap corner">
	<table class="article">
		<tr class="a-head">
			<td class="a-left">
<{if !($item.owner)}>
				<span class="a-u-name"><{$item.poster}></span>
				<span class="a-u-sex" > <samp title="隐藏" class="ico-pos-offline-hide" ></samp>
				</span>
<{else}>
				<span class="a-u-name"><a href="<{$base}>/user/query/<{$item.owner.id}>"><{$item.owner.id}></a></span>
				<span class="a-u-sex" >
				<samp
				<{if ($item.owner.gender == -1)}>
					<{if ($item.owner.online)}> title="性别保密哦 在线" class="ico-pos-online-hide" <{else}> title="性别保密哦 离线" class="ico-pos-offline-hide" <{/if}>
				<{elseif $item.owner.gender == 0}>
					<{if ($item.owner.online)}> title="男生哦 在线" class="ico-pos-online-man" <{else}> title="男生哦 离线" class="ico-pos-offline-man" <{/if}>
				<{else}>
					<{if ($item.owner.online)}> title="女生哦 在线" class="ico-pos-online-woman" <{else}> title="女生哦 离线" class="ico-pos-offline-woman" <{/if}>
				<{/if}>
				></samp>
				</span>
<{/if}>
			</td>
			<td>
				<ul class="a-func">
					<li><samp class="ico-pos-reply"></samp><a href="<{$base}>/article/<{$bName}>/post/<{$item.id}>" class="a-post">回复</a></li>
<{if $item.subject}>
					<li><samp class="ico-pos-template"></samp><a href="<{$base}>/article/<{$bName}>/tmpl?id=<{$item.id}>" class="a-post">模版回复</a></li>
<{/if}>
					<li><samp class="ico-pos-forward"></samp><a href="<{$base}>/article/<{$bName}>/ajax_forward/<{$item.id}>.json" class="a-func-forward">转寄</a></li>
					<li><samp class="ico-pos-search"></samp><a href="<{$base}>/s/article?b=<{$bName}>&au=<{$item.poster}>">搜索</a></li>
				<{if $item.op == "1"}>
					<li><samp class="ico-pos-edit"></samp><a href="<{$base}>/article/<{$bName}>/edit/<{$item.id}>">编辑</a></li>
					<li><samp class="ico-pos-del"></samp><a href="<{$base}>/article/<{$bName}>/ajax_delete/<{$item.id}>.json" class="a-func-del">删除</a></li>
				<{/if}>
				</ul>
				<span class="a-pos">
					<{if $item.pos == "0"}>
					楼主
					<{else}>
					第<{$item.pos}>楼
					<{/if}>
				</span>
			</td>
		</tr>
		<tr class="a-body">
			<td class="a-left">
<{if !($item.owner)}>
				&nbsp;
<{else}>
				<div class="a-u-img">
					<img src="<{$static}><{$base}><{$item.owner.furl}>" <{if $item.owner.width != ""}>width="<{$item.owner.width}>px"<{/if}> <{if $item.owner.height != ""}>height="<{$item.owner.height}>px"<{/if}> />
				</div>
				<div class="a-u-uid"><{$item.owner.name}></div>
				<dl class="a-u-info">
					<dt>等级</dt>
					<dd><{$item.owner.level}></dd>
					<dt>文章</dt>
					<dd><{$item.owner.post}></dd>
<{if !($item.owner.hide)}>
					<dt>星座</dt>
					<dd><{$item.owner.astro}></dd>
<{/if}>
				</dl>
<{/if}>
			</td>
			<td class="a-content">
				<{$item.content}>
                <{if isset($vinfo) && $item.pos=="0"}>
                    <div id="vote_view" class="corner" style="margin:0;display:inline-block">
                    <{include file="../plugins/vote/views/index/vote.tpl"}>  
                    </div>
                <{/if}>
			</td>
		</tr>
		<tr class="a-bottom">
			<td class="a-left">
<{if !($item.owner)}>
				&nbsp;
<{else}>
				<ul class="a-func a-func-info">
					<li><samp class="ico-pos-query"></samp><a href="<{$base}>/user/query/<{$item.owner.id}>">查看</a></li>
					<li><samp class="ico-pos-mess"></samp><a href="<{$base}>/mail/<{$bName}>/reply/<{$item.id}>?id=<{$item.owner.id}>" class="a-post">发信</a></li>
					<li><samp class="ico-pos-friend"></samp><a href="<{$base}>/friend/ajax_add.json?id=<{$item.owner.id}>" class="a-func-friend a-post">加好友</a></li>
				</ul>
<{/if}>
			</td>
			<td><a href="#" class="c63f a-back">返回顶部</a></td>
		</tr>
	</table>
    </div>
<{/foreach}>
        </div>
    <div class="t-pre-bottom">
        <div class="page">
            <ul class="pagination">
			  <li class="page-pre">主题数:<i><{$totalNum}></i>&emsp;分页:</li>
              <li><ol title="分页列表" class="page-main"><{$pageBar}></ol></li>
			  <li class="page-suf"></li>	
            </ul>
        </div>
    	<div class="t-btn">
        	<form id="f_search" method="get" action="<{$base}>/s/article">
        		<input id="a_search" type="text" class="input-text input" name="t1" value="输入关键字" />
                <input type="checkbox" name="m" id="c_m"/>
                <label for="c_m">精华帖</label>
                <input type="checkbox" name="a" id="c_a"/>
                <label for="c_a">带附件</label>
                <input type="submit" class="button" value="搜索" />
				<!--<input type="hidden" name="d" value="<{$searchDay}>" />-->
				<input type="hidden" name="b" value="<{$bName}>" />
            </form>
        </div>
    </div>
    <!--quick_reply start-->
	<form id="quick_post" method="post" action="<{$base}>/article/<{$bName}>/ajax_post.json" >
    <table id="quick_reply" class="corner">
        <tr>
            <td><textarea id="quick_text" name="content"></textarea></td>
            <td id="quick_submit"><input type="submit" class="button" value="快捷回复" /></td>
        </tr>
        <tr>
			<td colspan="2"><div id="em_img"></div></td>
        </tr>
    </table>
	<input type="hidden" name="id" value="<{$reid|default:0}>" />
	<input type="hidden" name="subject" value="<{$reTitle}>" />
	<{if $anony}>
	<input type="hidden" name="anony" value="1" />
	<{/if}>
    </form>
    <!--quick_reply end-->
<{include file="article/forward.tpl"}>
<{if isset($syntax)}><{include file="syntax_high_lighter.tpl"}><{/if}>
