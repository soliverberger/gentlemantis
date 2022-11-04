{capture assign='pageTitle'}{$thread->topic} {if $pageNo > 1}- {lang}wcf.page.pageNo{/lang} {/if} - {$board->getTitle()}{/capture}

{capture assign='contentHeader'}
	<header class="contentHeader messageGroupContentHeader wbbThread{if $thread->isDisabled} messageDisabled{/if}{if $thread->isDeleted} messageDeleted{/if}" data-thread-id="{@$thread->threadID}" data-is-closed="{@$thread->isClosed}" data-is-deleted="{@$thread->isDeleted}" data-is-disabled="{@$thread->isDisabled}" data-is-sticky="{@$thread->isSticky}" data-is-announcement="{@$thread->isAnnouncement}"{if WBB_MODULE_THREAD_MARKING_AS_DONE && $board->enableMarkingAsDone} data-is-done="{@$thread->isDone}" data-can-mark-as-done="{if $thread->canMarkAsDone()}1{else}0{/if}"{/if} data-is-link="{if $thread->movedThreadID}1{else}0{/if}">		

		<div class="contentHeaderTitle">
			<h1 class="contentTitle">{$thread->topic}</h1>
			<ul class="inlineList contentHeaderMetaData">
				{event name='beforeMetaData'}

				{hascontent}
					<li>
						<span class="icon icon16 fa-tags"></span>
						<ul class="labelList">
							{content}
								{event name='beforeLabels'}
								{foreach from=$thread->getLabels() item=label}
									<li>{@$label->render()}</li>
								{/foreach}
								{event name='afterLabels'}
							{/content}
						</ul>
					</li>
				{/hascontent}

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
				<ul>
					{content}
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
					"name": {@PAGE_TITLE|phrase|json},
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

{capture assign='__pageDataAttributes'}data-board-id="{@$thread->boardID}" data-thread-id="{@$thread->threadID}"{/capture}

{capture assign='contentInteractionPagination'}
	{pages print=true assign=pagesLinks application='wbb' controller='Thread' object=$thread link="pageNo=%d"}
{/capture}

{capture assign='contentInteractionButtons'}
	{if $thread->canEdit() && ($items > 0 || ($board->getModeratorPermission('canDeleteThread') && $board->getModeratorPermission('canDeleteThreadCompletely')))}
		<div class="contentInteractionButton jsThreadInlineEditorContainer" data-thread-id="{@$thread->threadID}" data-is-closed="{@$thread->isClosed}" data-is-sticky="{@$thread->isSticky}" data-is-disabled="{@$thread->isDisabled}">
			<a href="#" class="button small jsThreadInlineEditor jsOnly"><span class="icon icon16 fa-pencil"></span> <span>{lang}wbb.thread.edit{/lang}</span></a>
		</div>
	{/if}
	{if $__wcf->user->userID && !$thread->getBoard()->isIgnored()}
		<div class="dropdown contentInteractionButton">
			<a class="jsTooltip button small dropdownToggle jsSubscribeButton subscribeThreadStatusDropdownToggle{if $thread->isSubscribed() || $thread->isIgnored()} active{/if}" data-thread-id="{@$thread->threadID}" data-is-subscribed="{if $thread->isSubscribed()}1{else}0{/if}">
				<span class="icon icon16 fa-{if $thread->isSubscribed()}bookmark{elseif $thread->isIgnored()}ban{else}bookmark-o{/if}"></span>
				<span>{lang}{if $thread->isSubscribed()}wbb.thread.status.watching{elseif $thread->isIgnored()}wbb.thread.status.ignoring{else}wcf.user.objectWatch.button.subscribe{/if}{/lang}</span>
			</a>
			<ul class="dropdownMenu subscribeThreadStatusDropdown" data-thread-id="{@$thread->threadID}">
				<li class="subscribeThreadSelect{if !$thread->isSubscribed() && !$thread->isIgnored()} active{/if}" data-status="normal">
					<h3 class="subscribeThreadSelectHeader">{lang}wbb.thread.status.normal{/lang}</h3>
					<span class="subscribeThreadSelectDescription">{lang}wbb.thread.status.normal.description{/lang}</span>
				</li>
				<li class="subscribeThreadSelect{if $thread->isSubscribed()} active{/if}" data-status="watching">
					<h3 class="subscribeThreadSelectHeader">{lang}wbb.thread.status.watching{/lang}</h3>
					<span class="subscribeThreadSelectDescription">{lang}wbb.thread.status.watching.description{/lang}</span>
				</li>
				{if $thread->canBeIgnored()}
					<li class="subscribeThreadSelect{if $thread->isIgnored()} active{/if}" data-status="ignoring">
						<h3 class="subscribeThreadSelectHeader">{lang}wbb.thread.status.ignoring{/lang}</h3>
						<span class="subscribeThreadSelectDescription">{lang}wbb.thread.status.ignoring.description{/lang}</span>
					</li>
				{/if}
			</ul>
		</div>
	{/if}
	{if $officialPostMapping|isset && $pageNo == 1 && $officialPostMapping[null][next]}
		<a href="{$officialPostMapping[null][next]->getLink()}" class="contentInteractionButton button small"><span class="icon icon16 fa-arrow-right"></span> <span>{lang}wbb.post.official.first{/lang}</span></a>
	{/if}
{/capture}

{capture assign='contentInteractionDropdownItems'}
	{if $board->canEditThreads()}
		<li><a href="{link application='wbb' controller='ThreadLog' id=$thread->threadID}{/link}">{lang}wbb.thread.log{/lang}</a></li>
	{/if}
{/capture}

{include file='header'}

{if $thread->isDisabled && !$board->getModeratorPermission('canEnableThread')}
	<p class="info" role="status">{lang}wbb.thread.moderation.disabledThread{/lang}</p>
{/if}

{if $items > 0}
	<div class="section">
		<ul
			class="wbbThreadPostList messageList jsClipboardContainer"
			data-is-last-page="{if $isLastPage}true{else}false{/if}"
			data-last-post-time="{@$thread->lastPostTime|max:$objects->getMaxPostTime()}"
			data-page-no="{@$pageNo}"
			data-sort-order="{$sortOrder}"
			data-type="com.woltlab.wbb.post"
		>
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
								<a href="{link application='wbb' controller='Thread' object=$similarThread}{/link}">{@$similarThread->getUserProfile()->getAvatar()->getImageTag(48)}</a>

								<div class="containerBoxContent">
									<h3><a href="{$similarThread->getLink()}" {if $similarThread->getBoard()->getPermission('canReadThread')} class="wbbTopicLink"{/if} data-object-id="{@$similarThread->threadID}">{$similarThread->topic}</a></h3>
									<ul class="inlineList dotSeparated small">
										<li>{user object=$similarThread->getUserProfile()}</li>
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
			'wbb.post.official': '{jslang}wbb.post.official{/jslang}',
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
			'wbb.thread.edit.markPosts': '{jslang}wbb.thread.edit.markPosts{/jslang}',
			'wbb.thread.edit.markThread': '{jslang}wbb.thread.edit.markThread{/jslang}',
			'wbb.thread.edit.move': '{jslang}wbb.thread.edit.move{/jslang}',
			'wbb.thread.edit.moveDestination.error.equalsOrigin': '{jslang}wbb.thread.edit.moveDestination.error.equalsOrigin{/jslang}',
			'wbb.thread.edit.open': '{jslang}wbb.thread.edit.open{/jslang}',
			'wbb.thread.edit.removeLink': '{jslang}wbb.thread.edit.removeLink{/jslang}',
			'wbb.thread.edit.restore': '{jslang}wbb.thread.edit.restore{/jslang}',
			'wbb.thread.edit.scrape': '{jslang}wbb.thread.edit.scrape{/jslang}',
			'wbb.thread.edit.sticky': '{jslang}wbb.thread.edit.sticky{/jslang}',
			'wbb.thread.edit.trash': '{jslang}wbb.thread.edit.trash{/jslang}',
			'wbb.thread.edit.undone': '{jslang}wbb.thread.edit.undone{/jslang}',
			'wbb.thread.edit.unmarkThread': '{jslang}wbb.thread.edit.unmarkThread{/jslang}',
			'wbb.thread.moved': '{jslang}wbb.thread.moved{/jslang}',
			'wbb.thread.newPosts': '{jslang}wbb.thread.newPosts{/jslang}',
			'wbb.thread.sticky': '{jslang}wbb.thread.sticky{/jslang}',
			'wcf.global.worker.completed': '{jslang}wcf.global.worker.completed{/jslang}',
			'wcf.user.objectWatch.manageSubscription': '{jslang}wcf.user.objectWatch.manageSubscription{/jslang}',
			'wcf.message.bbcode.code.copy': '{jslang}wcf.message.bbcode.code.copy{/jslang}',
			'wcf.message.error.editorAlreadyInUse': '{jslang}wcf.message.error.editorAlreadyInUse{/jslang}',
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

		{assign var='canEditPostInline' value=false}
		{if $__wcf->user->userID}
			{if $board->canEditThreads() || $thread->getBoard()->getModeratorPermission('canClosePost') || $thread->getBoard()->getModeratorPermission('canDeletePost') || $thread->getBoard()->getModeratorPermission('canDeletePostCompletely') || $thread->getBoard()->getModeratorPermission('canEnablePost') || $thread->getBoard()->getModeratorPermission('canRestorePost')}
				{assign var='canEditPostInline' value=true}
			{/if}
		{/if}

		require(['WoltLabSuite/Forum/Controller/Thread', 'WoltLabSuite/Forum/Ui/Post/Quote', 'WoltLabSuite/Forum/Handler/Thread/ThreadUpdateHandler'], (ControllerThread, { UiPostQuote }, { ThreadUpdateHandler }) => {
			new UiPostQuote($quoteManager);

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
				var $updateHandler = new ThreadUpdateHandler({@$board->boardID});
				const postManager = ControllerThread.getPostManager();
				$updateHandler.setPostHandler(postManager);
				postManager.setThreadUpdateHandler($updateHandler);
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

					new WBB.Thread.Clipboard($updateHandler, 'thread', {@$thread->boardID});
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

		require(['WoltLabSuite/Forum/Ui/Thread/LastPageHandler'], (LastPageHandler) => {
			LastPageHandler.setup();
		});

		{if LOG_IP_ADDRESS && $__wcf->session->getPermission('admin.user.canViewIpAddress')}
			require(['WoltLabSuite/Forum/Ui/Post/IpAddressHandler'], ({ IpAddressHandler }) => {
				new IpAddressHandler();
			});
		{/if}

		{if $__wcf->session->getPermission('user.profile.canReportContent')}
			new WCF.Moderation.Report.Content('com.woltlab.wbb.post', '.jsReportPost');
		{/if}

		{if MODULE_USER_INFRACTION && $__wcf->session->getPermission('mod.infraction.warning.canWarn')}
			new WCF.Infraction.Warning.Content('com.woltlab.wbb.warnablePost', '.jsWarnPost');
		{/if}

		{if $thread->getBoard()->getModeratorPermission('canEditPost')}
			require([ 'WoltLabSuite/Forum/Ui/Thread/Modification/Log/Hide'], function (ThreadLogHideHandler) {
				ThreadLogHideHandler.init();
			});
		{/if}

		{if $__wcf->user->userID && !$thread->getBoard()->isIgnored()}
			require([ 'WoltLabSuite/Forum/Controller/Thread/SubscriptionStatusHandler', 'Language'], function ({ SubscriptionStatusHandler }, Language) {
				Language.addObject({
					'wbb.thread.status.watching': '{jslang}wbb.thread.status.watching{/jslang}',
					'wbb.thread.status.ignoring': '{jslang}wbb.thread.status.ignoring{/jslang}',
					'wbb.thread.status.normal': '{jslang}wbb.thread.status.normal{/jslang}',
					'wcf.user.objectWatch.button.subscribe': '{jslang}wcf.user.objectWatch.button.subscribe{/jslang}',
				})

				new SubscriptionStatusHandler();
			});
		{/if}
	});
</script>

{if $board->canEditThreads()}
	<div class="jsClipboardContainer" data-type="com.woltlab.wbb.thread" style="display: none;">
		<div class="jsClipboardObject">
			<input id="wbbThreadClipboardMark" type="checkbox" class="jsClipboardItem" data-object-id="{@$thread->threadID}">
		</div>
	</div>
{/if}

{include file='footer'}
