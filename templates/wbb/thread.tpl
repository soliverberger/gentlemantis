{capture assign='pageTitle'}{$thread->topic} {if $pageNo > 1}- {lang}wcf.page.pageNo{/lang} {/if} - {$board->getTitle()}{/capture}

{assign var='__pageCssClassName' value='mobileShowPaginationTop'}

{capture assign='contentHeader'}
	<header class="contentHeader messageGroupContentHeader wbbThread{if $thread->isDisabled} messageDisabled{/if}{if $thread->isDeleted} messageDeleted{/if}" data-thread-id="{@$thread->threadID}"{if $thread->canEdit()} data-is-closed="{@$thread->isClosed}" data-is-deleted="{@$thread->isDeleted}" data-is-disabled="{@$thread->isDisabled}" data-is-sticky="{@$thread->isSticky}" data-is-announcement="{@$thread->isAnnouncement}"{/if}{if WBB_MODULE_THREAD_MARKING_AS_DONE && $board->enableMarkingAsDone} data-is-done="{@$thread->isDone}" data-can-mark-as-done="{if $thread->canMarkAsDone()}1{else}0{/if}"{/if} data-is-link="{if $thread->movedThreadID}1{else}0{/if}">
		<div class="contentHeaderIcon">
			{@$thread->getUserProfile()->getAvatar()->getImageTag(64)}
			
			{if $thread->isAnnouncement}<span class="icon icon16 fa-bullhorn jsTooltip wbbAnnouncementIcon" title="{lang}wbb.thread.announcement{/lang}"></span>{/if}
			{if $thread->isSticky}<span class="icon icon16 fa-thumb-tack jsTooltip jsIconSticky wbbStickyIcon" title="{lang}wbb.thread.sticky{/lang}"></span>{/if}
			{event name='icons'}
		</div>
		
		<div class="contentHeaderTitle">
			<h1 class="contentTitle">{$thread->topic}</h1>
			<ul class="inlineList contentHeaderMetaData">
				{event name='beforeMetaData'}
				
				{if $thread->hasLabels()}
					<li>
						<span class="icon icon16 fa-tags"></span>
						<ul class="labelList">
							{foreach from=$thread->getLabels() item=label}
								<li>{@$label->render()}</li>
							{/foreach}
						</ul>
					</li>
				{/if}
								
				<li>
					<span class="icon icon16 fa-clock-o"></span>
					<a href="{link application='wbb' controller='Thread' object=$thread}{/link}">{@$thread->time|time}</a>
				</li>
				
				{if $thread->isClosed}
					<li>
						<span class="icon icon16 fa-lock jsIconClosed"></span>
						{lang}wbb.thread.closed{/lang}
					</li>
				{/if}
				
				{if WBB_MODULE_THREAD_MARKING_AS_DONE && $board->enableMarkingAsDone}
					<li class="jsMarkAsDone">
						{if $thread->isDone}
							<span class="icon icon16 fa-check-square-o"></span>
							<span>{lang}wbb.thread.done{/lang}</span>
						{else}
							<span class="icon icon16 fa-square-o"></span>
							<span>{lang}wbb.thread.undone{/lang}</span>
						{/if}
					</li>
				{/if}
				
				{event name='afterMetaData'}
			</ul>
		</div>
		
		{hascontent}
			<nav class="contentHeaderNavigation">
				<ul class="jsThreadInlineEditorContainer" data-thread-id="{@$thread->threadID}" data-is-closed="{@$thread->isClosed}" data-is-sticky="{@$thread->isSticky}" data-is-disabled="{@$thread->isDisabled}">
					{content}
						{if $thread->canEdit() && ($items > 0 || ($board->getModeratorPermission('canDeleteThread') && $board->getModeratorPermission('canDeleteThreadCompletely')))}
							<li><a href="#" class="button jsThreadInlineEditor jsOnly"><span class="icon icon16 fa-pencil"></span> <span>{lang}wbb.thread.edit{/lang}</span></a></li>
						{/if}
						{if $sortOrder == 'ASC' && $thread->canReply()}<li class="wbbPostAddButton"><a href="#" title="{lang}wbb.post.add{/lang}" class="button buttonPrimary jsQuickReply"><span class="icon icon16 fa-reply"></span> <span>{lang}wbb.post.button.add{/lang}</span></a></li>{/if}
						{event name='contentHeaderNavigation'}
					{/content}
				</ul>
			</nav>
		{/hascontent}
	</header>
{/capture}

{capture assign='headContent'}
	{if $pageNo < $pages}
		<link rel="next" href="{link application='wbb' controller='Thread' object=$thread}pageNo={@$pageNo+1}{/link}">
	{/if}
	{if $pageNo > 1}
		<link rel="prev" href="{link application='wbb' controller='Thread' object=$thread}{if $pageNo > 2}pageNo={@$pageNo-1}{/if}{/link}">
	{/if}
	
	{if $board->enableBestAnswer && $items > 0}
		<script type="application/ld+json">
			{
				"@context": "http://schema.org",
				"@type": "Question",
				"name": {@$thread->topic|json},
				"upvoteCount": "{$thread->getFirstPost()->cumulativeLikes}",
				"text": {@$thread->getFirstPost()->getPlainTextMessage()|json},
				"dateCreated": "{@$thread->time|date:'c'}",
				"author": {
					"@type": "Person",
					"name": {@$thread->getUserProfile()->username|json}
				},
				"answerCount": "{$thread->replies}"{if $thread->bestAnswerPostID},
					"acceptedAnswer": {
						"@type": "Answer",
						"upvoteCount": "{$thread->getBestAnswerPost()->cumulativeLikes}",
						"text": {@$thread->getBestAnswerPost()->getPlainTextMessage()|json},
						"dateCreated": "{@$thread->getBestAnswerPost()->time|date:'c'}",
						"author": {
							"@type": "Person",
							"name": {@$thread->getBestAnswerPost()->username|json}
						}
					}
				{/if}
			}
		</script>
	{/if}
	
	{if $items > 0}
		<script type="application/ld+json">
			{
				"@context": "http://schema.org",
				"@type": "DiscussionForumPosting",
				"@id": {@$canonicalURL|json},
				"mainEntityOfPage": {@$canonicalURL|json},
				"headline": {@$thread->topic|json},
				"articleBody": {@$thread->getFirstPost()->getPlainTextMessage()|json},
				"articleSection": {@$thread->getBoard()->getTitle()|json},
				"datePublished": "{@$thread->time|date:'c'}",
				"dateModified": "{if $thread->getFirstPost()->editCount}{@$thread->getFirstPost()->lastEditTime|date:'c'}{else}{@$thread->time|date:'c'}{/if}",
				"author": {
					"@type": "Person",
					"name": {@$thread->getUserProfile()->username|json}
				},
				"image": {@$__wcf->getStyleHandler()->getStyle()->getPageLogo()|json},
				"interactionStatistic": {
					"@type": "InteractionCounter",
					"interactionType": "https://schema.org/ReplyAction",
					"userInteractionCount": {@$thread->replies}
				},
				"publisher": {
					"@type": "Organization",
					"name": {@PAGE_TITLE|language|json},
					"logo": {
						"@type": "ImageObject",
						"url": {@$__wcf->getStyleHandler()->getStyle()->getPageLogo()|json},
						"width": {@$__wcf->getStyleHandler()->getStyle()->getVariable('pageLogoWidth')},
						"height": {@$__wcf->getStyleHandler()->getStyle()->getVariable('pageLogoHeight')}
					}
				}
			}
		</script>
	{/if}
{/capture}

{capture assign='headerNavigation'}
	{if $__wcf->user->userID}
		<li class="jsOnly"><a href="#" title="{lang}wcf.user.objectWatch.manageSubscription{/lang}" class="jsSubscribeButton jsTooltip" data-object-type="com.woltlab.wbb.thread" data-object-id="{@$thread->threadID}" data-is-subscribed="{if $thread->isSubscribed()}true{else}false{/if}"><span class="icon icon16 fa-bookmark{if !$thread->isSubscribed()}-o{/if}"></span> <span class="invisible">{lang}wcf.user.objectWatch.manageSubscription{/lang}</span></a></li>
	{/if}
	{if $board->canEditThreads()}
		<li><a href="{link application='wbb' controller='ThreadLog' id=$thread->threadID}{/link}" title="{lang}wbb.thread.log{/lang}" class="jsTooltip"><span class="icon icon16 fa-tasks"></span> <span class="invisible">{lang}wbb.thread.log{/lang}</span></a></li>
	{/if}
{/capture}

{capture assign='__pageDataAttributes'}data-board-id="{@$thread->boardID}" data-thread-id="{@$thread->threadID}"{/capture}

{include file='header'}

{if $thread->isDisabled && !$board->getModeratorPermission('canEnableThread')}
	<p class="info" role="status">{lang}wbb.thread.moderation.disabledThread{/lang}</p>
{/if}

{hascontent}
	<div class="paginationTop">
		{content}{pages print=true assign=pagesLinks application='wbb' controller='Thread' object=$thread link="pageNo=%d"}{/content}
	</div>
{/hascontent}

{if $items > 0}
	<div class="section">
		<ul class="wbbThreadPostList messageList jsClipboardContainer" data-type="com.woltlab.wbb.post">
			{if $sortOrder == 'DESC' && $thread->canReply()}
				{assign var='tmpAttachmentList' value=$attachmentList}
				{include file='threadQuickReply' application='wbb'}
				{assign var='attachmentList' value=$tmpAttachmentList}
			{/if}
			{if $sortOrder == 'DESC'}{assign var=startIndex value=$items-$startIndex+1}{/if}
			{include file='threadPostList' application='wbb'}
			{if $__wcf->user->userID && $thread->isClosed && !$thread->canReply() && !($hideClosedForNewRepliesNotice|isset && $hideClosedForNewRepliesNotice)}
				<li class="messageListNotice">
					<div class="info" role="status">{lang}wbb.thread.closedForNewReplies{/lang}</div>
				</li>
			{/if}
			{if $numberOfHiddenPosts > 0}
				<li class="messageListNotice">
					<div class="info" role="status">{lang}wbb.post.hiddenForGuests{/lang}</div>
				</li>
			{/if}
			{hascontent}
				<li class="messageListPagination">
					{content}{@$pagesLinks}{/content}
				</li>
			{/hascontent}
			{if $sortOrder == 'ASC' && $thread->canReply()}{include file='threadQuickReply' application='wbb'}{/if}
		</ul>
	</div>
{elseif $thread->canEdit() && $board->getModeratorPermission('canDeleteThread') && $board->getModeratorPermission('canDeleteThreadCompletely')}
	<p class="error">{lang}wbb.thread.noPosts{/lang}</p>
{else}
	<p class="info">{lang}wcf.global.noItems{/lang}</p>
{/if}

{capture assign='footerBoxes'}
	{if ENABLE_SHARE_BUTTONS}
		<section class="box boxFullWidth jsOnly">
			<h2 class="boxTitle">{lang}wcf.message.share{/lang}</h2>
			
			<div class="boxContent">
				{include file='shareButtons'}
			</div>
		</section>
	{/if}
	
	{if $similarThreadList && $similarThreadList->getObjects()|count}
		<section class="box wbbSimilarThreadList boxFullWidth">
			<h2 class="boxTitle">{lang}wbb.thread.similarThreads{/lang}</h2>
			
			<div class="boxContent">
				<ul class="containerBoxList tripleColumned">
					{foreach from=$similarThreadList item=similarThread}
						<li>
							<div class="box48">
								<a href="{link application='wbb' controller='Thread' object=$similarThread}{/link}" title="{@$similarThread->username}">{@$similarThread->getUserProfile()->getAvatar()->getImageTag(48)}</a>
								
								<div class="containerBoxContent">
									<h3><a href="{$similarThread->getLink()}" {if $similarThread->getBoard()->getPermission('canReadThread')} class="wbbTopicLink"{/if} data-object-id="{@$similarThread->threadID}">{$similarThread->topic}</a></h3>
									<ul class="inlineList dotSeparated small">
										<li>{if $similarThread->userID}{user object=$similarThread->getUserProfile()}{else}{$similarThread->username}{/if}</li>
										<li>{@$similarThread->time|time}</li>
									</ul>
									<ul class="inlineList dotSeparated small">
										<li><a href="{link application='wbb' controller='Board' object=$similarThread->getBoard()}{/link}">{$similarThread->getBoard()->getTitle()}</a></li>
									</ul>
								</div>
							</div>
						</li>
					{/foreach}
				</ul>
			</div>
		</section>
	{/if}
	
	{if $tags|count}
		<section class="box">
			<h2 class="boxTitle">{lang}wcf.tagging.tags{/lang}</h2>
			
			<div class="boxContent">
				<ul class="tagList">
					{foreach from=$tags item=tag}
						<li><a href="{link controller='Tagged' object=$tag}objectType=com.woltlab.wbb.thread{/link}" class="tag jsTooltip" title="{lang}wcf.tagging.taggedObjects.com.woltlab.wbb.thread{/lang}">{$tag->name}</a></li>
					{/foreach}
				</ul>
			</div>
		</section>
	{/if}
	
	{event name='infoBoxes'}
{/capture}

<script data-relocate="true" src="{@$__wcf->getPath()}js/WCF.Infraction{if !ENABLE_DEBUG_MODE}.min{/if}.js?v={@LAST_UPDATE_TIME}"></script>
<script data-relocate="true">
	$(function() {
		WCF.Language.addObject({
			'wbb.post.closed': '{jslang}wbb.post.closed{/jslang}',
			'wbb.post.copy.title': '{jslang}wbb.post.copy.title{/jslang}',
			'wbb.post.edit': '{jslang}wbb.post.edit{/jslang}',
			'wbb.post.edit.close': '{jslang}wbb.post.edit.close{/jslang}',
			'wbb.post.edit.delete': '{jslang}wbb.post.edit.trash{/jslang}',
			'wbb.post.edit.delete.confirmMessage': '{jslang}wbb.post.edit.delete.confirmMessage{/jslang}',
			'wbb.post.edit.deleteCompletely': '{jslang}wbb.post.edit.delete{/jslang}',
			'wbb.post.edit.enable': '{jslang}wbb.post.edit.enable{/jslang}',
			'wbb.post.edit.disable': '{jslang}wbb.post.edit.disable{/jslang}',
			'wbb.post.edit.merge': '{jslang}wbb.post.edit.merge{/jslang}',
			'wbb.post.edit.merge.success': '{jslang}wbb.post.edit.merge.success{/jslang}',
			'wbb.post.edit.open': '{jslang}wbb.post.edit.open{/jslang}',
			'wbb.post.edit.restore': '{jslang}wbb.post.edit.restore{/jslang}',
			'wbb.post.edit.trash.confirmMessage': '{jslang}wbb.post.edit.trash.confirmMessage{/jslang}',
			'wbb.post.edit.trash.reason': '{jslang}wbb.post.edit.trash.reason{/jslang}',
			'wbb.post.ipAddress.title': '{jslang}wbb.post.ipAddress.title{/jslang}',
			'wbb.post.moderation.redirect': '{jslang}wbb.post.moderation.redirect{/jslang}',
			'wbb.post.moveToNewThread': '{jslang}wbb.post.moveToNewThread{/jslang}',
			'wbb.thread.closed': '{jslang}wbb.thread.closed{/jslang}',
			'wbb.thread.confirmDelete': '{jslang}wbb.thread.confirmDelete{/jslang}',
			'wbb.thread.confirmTrash': '{jslang}wbb.thread.confirmTrash{/jslang}',
			'wbb.thread.confirmTrash.reason': '{jslang}wbb.thread.confirmTrash.reason{/jslang}',
			'wbb.thread.edit.advanced': '{jslang}wbb.thread.edit.advanced{/jslang}',
			'wbb.thread.edit.close': '{jslang}wbb.thread.edit.close{/jslang}',
			'wbb.thread.edit.delete': '{jslang}wbb.thread.edit.delete{/jslang}',
			'wbb.thread.edit.done': '{jslang}wbb.thread.edit.done{/jslang}',
			'wbb.thread.edit.enable': '{jslang}wbb.thread.edit.enable{/jslang}',
			'wbb.thread.edit.disable': '{jslang}wbb.thread.edit.disable{/jslang}',
			'wbb.thread.edit.move': '{jslang}wbb.thread.edit.move{/jslang}',
			'wbb.thread.edit.moveDestination.error.equalsOrigin': '{jslang}wbb.thread.edit.moveDestination.error.equalsOrigin{/jslang}',
			'wbb.thread.edit.open': '{jslang}wbb.thread.edit.open{/jslang}',
			'wbb.thread.edit.removeLink': '{jslang}wbb.thread.edit.removeLink{/jslang}',
			'wbb.thread.edit.restore': '{jslang}wbb.thread.edit.restore{/jslang}',
			'wbb.thread.edit.scrape': '{jslang}wbb.thread.edit.scrape{/jslang}',
			'wbb.thread.edit.sticky': '{jslang}wbb.thread.edit.sticky{/jslang}',
			'wbb.thread.edit.trash': '{jslang}wbb.thread.edit.trash{/jslang}',
			'wbb.thread.edit.undone': '{jslang}wbb.thread.edit.undone{/jslang}',
			'wbb.thread.moved': '{jslang}wbb.thread.moved{/jslang}',
			'wbb.thread.newPosts': '{jslang}wbb.thread.newPosts{/jslang}',
			'wbb.thread.sticky': '{jslang}wbb.thread.sticky{/jslang}',
			'wcf.global.worker.completed': '{jslang}wcf.global.worker.completed{/jslang}',
			'wcf.user.objectWatch.manageSubscription': '{jslang}wcf.user.objectWatch.manageSubscription{/jslang}',
			'wcf.message.bbcode.code.copy': '{jslang}wcf.message.bbcode.code.copy{/jslang}',
			'wcf.message.error.editorAlreadyInUse': '{jslang}wcf.message.error.editorAlreadyInUse{/jslang}',
			'wcf.message.share': '{jslang}wcf.message.share{/jslang}',
			'wcf.message.share.permalink': '{jslang}wcf.message.share.permalink{/jslang}',
			'wcf.message.share.permalink.bbcode': '{jslang}wcf.message.share.permalink.bbcode{/jslang}',
			'wcf.message.share.permalink.html': '{jslang}wcf.message.share.permalink.html{/jslang}',
			'wcf.message.status.deleted': '{jslang}wcf.message.status.deleted{/jslang}',
			'wcf.message.status.disabled': '{jslang}wcf.message.status.disabled{/jslang}',
			'wcf.moderation.report.reportContent': '{jslang}wcf.moderation.report.reportContent{/jslang}',
			'wcf.moderation.report.success': '{jslang}wcf.moderation.report.success{/jslang}',
			'wcf.infraction.warn': '{jslang}wcf.infraction.warn{/jslang}',
			'wcf.infraction.warn.success': '{jslang}wcf.infraction.warn.success{/jslang}',
			'wbb.thread.edit.moveThreads': '{jslang}wbb.thread.edit.moveThreads{/jslang}',
			'wbb.thread.edit': '{jslang}wbb.thread.edit{/jslang}',
			'wcf.label.none': '{jslang}wcf.label.none{/jslang}',
			'wbb.thread.done': '{jslang}wbb.thread.done{/jslang}',
			'wbb.thread.undone': '{jslang}wbb.thread.undone{/jslang}',
			'wbb.thread.modification.log.thread.hide.confirmMessage': '{jslang}wbb.thread.modification.log.thread.hide.confirmMessage{/jslang}'
		});
		
		{if $__wcf->user->userID && $thread->canReply()}
			{assign var='supportPaste' value=true}
		{else}
			{assign var='supportPaste' value=false}
		{/if}
		var $quoteManager = null;
		{include file='__messageQuoteManager' wysiwygSelector='text'}
		new WBB.Post.QuoteHandler($quoteManager);
		
		{assign var='canEditPostInline' value=false}
		{if $__wcf->user->userID}
			{if $board->canEditThreads() || $thread->getBoard()->getModeratorPermission('canClosePost') || $thread->getBoard()->getModeratorPermission('canDeletePost') || $thread->getBoard()->getModeratorPermission('canDeletePostCompletely') || $thread->getBoard()->getModeratorPermission('canEnablePost') || $thread->getBoard()->getModeratorPermission('canRestorePost')}
				{assign var='canEditPostInline' value=true}
			{/if}
		{/if}
		
		require(['WoltLabSuite/Forum/Controller/Thread'], function(ControllerThread) {
			ControllerThread.init({@$thread->threadID}, {
				clipboard: true,
				postInlineEditor: {if $__wcf->user->userID}true{else}false{/if},
				postLoader: {if $board->getModeratorPermission('canReadDeletedPost')}true{else}false{/if},
				postManager: {if $__wcf->user->userID}true{else}false{/if},
				postLikeHandler: {if MODULE_LIKE}true{else}false{/if}
			}, {
				clipboard: {
					hasMarkedItems: {if $hasMarkedItems}true{else}false{/if}
				},
				postInlineEditor: {
					canEditInline: {if $canEditPostInline}true{else}false{/if},
					quoteManager: $quoteManager
				}
			});
			
			{if $__wcf->user->userID}
				var $updateHandler = new WBB.Thread.UpdateHandler.Thread({@$board->boardID});
				$updateHandler.setPostHandler(ControllerThread.getPostManager());
				{if WBB_MODULE_THREAD_MARKING_AS_DONE && $board->enableMarkingAsDone}
					new WBB.Thread.MarkAsDone($updateHandler);
				{/if}
				
				{if $thread->canEdit() && ($items > 0 || ($board->getModeratorPermission('canDeleteThread') && $board->getModeratorPermission('canDeleteThreadCompletely')))}
					WCF.Language.addObject({
						'wbb.thread.closedThread': '{jslang}wbb.thread.closedThread{/jslang}'
					});
					
					var $inlineEditor = new WBB.Thread.InlineEditor('.jsThreadInlineEditorContainer');
					$inlineEditor.setUpdateHandler($updateHandler);
					$inlineEditor.setEnvironment('thread', {@$board->boardID});
					$inlineEditor.setPermissions({
						canCloseThread: {if $board->getModeratorPermission('canCloseThread') && $items > 0}true{else}false{/if},
						canDeleteThread: {if $board->getModeratorPermission('canDeleteThread')}true{else}false{/if},
						canDeleteThreadCompletely: {if $board->getModeratorPermission('canDeleteThreadCompletely')}true{else}false{/if},
						canEnableThread: {if $board->getModeratorPermission('canEnableThread') && $items > 0}true{else}false{/if},
						canMoveThread: {if $board->getModeratorPermission('canMoveThread') && $items > 0}true{else}false{/if},
						canPinThread: {if $board->getModeratorPermission('canPinThread') && $items > 0}true{else}false{/if},
						canRestoreThread: {if $board->getModeratorPermission('canRestoreThread') && $items > 0}true{else}false{/if}
					});
					{if $items === 0}
						$inlineEditor.disableAdvancedOptions();
					{/if}
				{/if}
				
				{if $canEditPostInline}
					var $postClipboardHandler = new WBB.Post.Clipboard(ControllerThread.getPostManager());
					$postClipboardHandler.setThreadUpdateHandler($updateHandler);
				{/if}
			{/if}
		});
		
		{if $thread->canReply() && $items > 0}
			require(['WoltLabSuite/Core/Ui/Message/Reply'], function(UiMessageReply) {
				new UiMessageReply({
					ajax: {
						className: 'wbb\\data\\post\\PostAction'
					},
					quoteManager: $quoteManager
				});
			});
		{/if}
		
		{if $thread->canMarkBestAnswer()}
			require(['WoltLabSuite/Forum/Ui/Thread/BestAnswer', 'Language'], function(BestAnswer, Language) {
				Language.addObject({
					'wbb.thread.markAsBestAnswer.confirmMessage': '{jslang}wbb.thread.markAsBestAnswer.confirmMessage{/jslang}'
				});
				
				BestAnswer.init({@$thread->threadID});
			});
		{/if}
		
		{if $isLastPage && $sortOrder == 'ASC'}new WBB.Thread.LastPageHandler({@$thread->threadID}, {@$thread->lastPostTime|max:$objects->getMaxPostTime()}, {@$pageNo});{/if}
		
		{if LOG_IP_ADDRESS && $__wcf->session->getPermission('admin.user.canViewIpAddress')}new WBB.Post.IPAddressHandler();{/if}
		
		{if $__wcf->session->getPermission('user.profile.canReportContent')}
			new WCF.Moderation.Report.Content('com.woltlab.wbb.post', '.jsReportPost');
		{/if}
		
		{if MODULE_USER_INFRACTION && $__wcf->session->getPermission('mod.infraction.warning.canWarn')}
			new WCF.Infraction.Warning.Content('com.woltlab.wbb.warnablePost', '.jsWarnPost');
		{/if}
		
		new WCF.User.ObjectWatch.Subscribe();
		
		{if ENABLE_SHARE_BUTTONS}
			{capture assign='shareButtonsTemplate'}{include file='shareButtons'}{/capture}
			new WCF.Message.Share.Content('{@$shareButtonsTemplate|encodeJS}');
		{else}
			new WCF.Message.Share.Content();
		{/if}
		
		{if $thread->getBoard()->getModeratorPermission('canEditPost')}
			require([ 'WoltLabSuite/Forum/Ui/Thread/Modification/Log/Hide'], function (ThreadLogHideHandler) {
				ThreadLogHideHandler.init();
			});
		{/if}
	});
</script>

{include file='footer'}
