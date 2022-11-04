{capture assign='pageTitle'}{$image->title}{/capture}

{capture assign='contentHeader'}
	<header class="contentHeader messageGroupContentHeader galleryImageHeadline{if $image->isDisabled} messageDisabled{/if}{if $image->isDeleted} messageDeleted{/if}">
		<div class="contentHeaderIcon">
			{@$image->getUserProfile()->getAvatar()->getImageTag(64)}
		</div>
		
		<div class="contentHeaderTitle">
			<h1 class="contentTitle">
				<span>{$image->title}</span>
			</h1>
			<ul class="inlineList contentHeaderMetaData">
				{event name='beforeMetaData'}

				<li>
					<span class="icon icon16 fa-user"></span>
					{user object=$image->getUserProfile()}
				</li>
				
				<li>
					<span class="icon icon16 fa-clock-o"></span>
					<a href="{$image->getLink()}">{@$image->uploadTime|time}</a>
				</li>

				{event name='afterMetaData'}
			</ul>
		</div>
		
		{hascontent}
			<nav class="contentHeaderNavigation">
				<ul>
					{content}
						{event name='contentHeaderNavigation'}
					{/content}
				</ul>
			</nav>
		{/hascontent}
	</header>
{/capture}

{capture assign='boxesContentTop'}
	{if $image->getAlbum() && $albumImageList|count > 1}
		<section class="box gallerySidebarBoxImageNavigation">
			<h2 class="boxTitle">{lang}gallery.image.albumImage{/lang}</h2>
			
			<div class="boxContent">
				<ul>
					<li class="galleryNavigationArrow galleryNavigationArrowPrevious{if $albumImageList|count <= 3} disabled{/if}"><span class="icon icon16 fa-arrow-left{if $albumImageList|count > 3} pointer{/if}"></span></li>
					<li>
						<ul id="galleryAlbumImageNavigation">
							{foreach from=$albumImageList item='__image'}
								<li{if $__image->imageID == $image->imageID} class="active"{/if}><a href="{$__image->getLink()}" class="jsTooltip" title="{$__image->title}">{@$__image->getTinyThumbnail()}</a></li>
							{/foreach}
						</ul>
					</li>
					<li class="galleryNavigationArrow galleryNavigationArrowNext{if $albumImageList|count <= 3} disabled{/if}"><span class="icon icon16 fa-arrow-right{if $albumImageList|count > 3} pointer{/if}"></span></li>
				</ul>
			</div>
		</section>
	{/if}
{/capture}

{capture assign='boxesContentBottom'}
	<section class="box">
		<h2 class="boxTitle">{lang}gallery.image.information{/lang}</h2>
		
		<div class="boxContent">
			<dl class="plain dataList">
				<dt>{lang}gallery.image.views{/lang}</dt>
				<dd>{#$image->views}</dd>
				
				{if $image->favorites}
					<dt>{lang}gallery.image.favorites{/lang}</dt>
					<dd>{#$image->favorites}</dd>
				{/if}
				
				{if !$image->isVideoLink}
					<dt>{lang}gallery.image.filename{/lang}</dt>
					<dd>{if $image->isImage()}{$image->filename}{else}{$image->videoFilename}{/if}</dd>
				{/if}
				
				{if $image->creationTime}
					<dt>{lang}gallery.image.creationTime{/lang}</dt>
					<dd>{@$image->creationTime|time}</dd>
				{/if}
				
				<dt>{lang}gallery.image.uploadTime{/lang}</dt>
				<dd>{@$image->uploadTime|time}</dd>
				
				{if $image->isImage()}
					<dt>{lang}gallery.image.size{/lang}</dt>
					<dd>{#$image->width} &times; {#$image->height}</dd>
				{/if}
				
				{if !$image->isVideoLink}
					<dt>{lang}gallery.image.filesize{/lang}</dt>
					<dd>{if $image->isImage()}{@$image->filesize|filesize}{else}{@$image->videoFilesize|filesize}{/if}</dd>
				{/if}
				
				{if $image->latitude != 0.0 && $image->longitude != 0.0}
					<dt>{lang}gallery.image.coordinates{/lang}</dt>
					<dd>{$image->getCoordinates()}</dd>
				{/if}
				
				{if LOG_IP_ADDRESS && $image->ipAddress && $__wcf->session->getPermission('admin.user.canViewIpAddress')}
					<dt>{lang}wcf.user.ipAddress{/lang}</dt>
					<dd>{$image->getIpAddress()}</dd>
				{/if}
				
				{if $image->isImage()}
					{if $image->camera}
						<dt>{lang}gallery.image.camera{/lang}</dt>
						<dd><a href="{link controller='ImageList' application='gallery'}camera={$image->camera|rawurlencode}{/link}">{$image->camera}</a></dd>
					{/if}
					
					{if $image->getExifData('ExposureTime')}
						<dt>{lang}gallery.image.exif.exposureTime{/lang}</dt>
						<dd>{$image->getExifData('ExposureTime')} s</dd>
					{/if}
					
					{if $image->getExifData('FNumber')}
						<dt>{lang}gallery.image.exif.aperture{/lang}</dt>
						<dd>f/{$image->getExifData('FNumber')}</dd>
					{/if}
					
					{if $image->getExifData('FocalLength')}
						<dt>{lang}gallery.image.exif.focalLength{/lang}</dt>
						<dd>{#$image->getExifData('FocalLength')}mm</dd>
					{/if}
					
					{if $image->getExifData('ISOSpeedRatings')}
						<dt>{lang}gallery.image.exif.iso{/lang}</dt>
						<dd>{$image->getExifData('ISOSpeedRatings')}</dd>
					{/if}
					
					{if $image->getExifData('Flash')}
						<dt>{lang}gallery.image.exif.flash{/lang}</dt>
						<dd>{lang}gallery.image.exif.flash.{@$image->getExifData('Flash')}{/lang}</dd>
					{/if}
				{/if}
				
				{event name='imageInformationList'}
			</dl>
		</div>
	</section>
	

	
	{if $image->getMarkedUsers()|count}
		<section class="box" id="galleryImageMarkedUserListContainer">
			<h2 class="boxTitle">{lang}gallery.image.markedUsers{/lang}</h2>
			
			<div class="boxContent">
				<ul class="inlineDataList">
					{foreach from=$image->getMarkedUsers() item=markedUser}
						<li><a href="{$markedUser->getLink()}" class="jsGalleryImageMarkedUser" data-user-id="{@$markedUser->userID}">{@$markedUser->getFormattedUsername()}</a></li>
					{/foreach}
				</ul>
			</div>
			
			<div class="boxContent">
				<small>{lang}gallery.image.markedUsers.description{/lang}</small>
			</div>
		</section>
	{/if}
	
	{if $tags|count}
		<section class="box">
			<h2 class="boxTitle">{lang}wcf.tagging.tags{/lang}</h2>
			
			<div class="boxContent">
				<ul class="tagList">
					{foreach from=$tags item=tag}
						<li><a href="{link controller='Tagged' object=$tag}objectType=com.woltlab.gallery.image{/link}" class="jsTooltip tag" title="{lang}wcf.tagging.taggedObjects.com.woltlab.gallery.image{/lang}">{$tag->name}</a></li>
					{/foreach}
				</ul>
			</div>
		</section>
	{/if}
	
	{if GOOGLE_MAPS_API_KEY && $image->latitude != 0.0 && $image->longitude != 0.0}
		<section class="box">
			<h2 class="boxTitle">{lang}gallery.image.map{/lang}</h2>
			{if $image->location}
				<small>{$image->location}</small>
			{/if}
			
			<div class="boxContent">
				<div class="sidebarGoogleMap" id="imageMap"></div>
			</div>
		</section>
	{/if}
	
	{event name='boxes'}
{/capture}

{capture assign='contentInteractionButtons'}
	{if $image->largeThumbnailSize}
		<a href="{$image->getURL()}" class="contentInteractionButton button small"><span class="icon icon16 fa-search-plus"></span> <span>{lang}gallery.image.viewFullSize{/lang}</span></a>
	{/if}
{/capture}

{include file='header'}

{event name='imageBefore'}

<div class="section galleryImageContainer"
	{@$__wcf->getReactionHandler()->getDataAttributes('com.woltlab.gallery.likeableImage', $image->imageID)}
>
	<div class="section galleryImage{if $image->isVideo} galleryVideo{/if}{if $image->isVideoLink} galleryVideoLink{/if}{if $image->hasMarkers} galleryImageMarkerContainer{/if}{if $previousImage} galleryImageHasPreviousImage{/if}{if $nextImage} galleryImageHasNextImage{/if}" data-object-id="{@$image->imageID}" data-is-deleted="{@$image->isDeleted}" data-is-disabled="{@$image->isDisabled}">
		{if $previousImage}
			<a class="galleryPreviousImageButton jsTooltip" href="{$previousImage->getLink()}" title="{lang}gallery.image.previousImage{/lang}"><span class="icon icon32 fa-chevron-left"></span></a>
		{/if}
		{if $nextImage}
			<a class="galleryNextImageButton jsTooltip" href="{$nextImage->getLink()}" title="{lang}gallery.image.nextImage{/lang}"><span class="icon icon32 fa-chevron-right"></span></a>
		{/if}
		
		{if $image->isVideo}
			<div class="galleryVideoContainer">
				<div class="videoContainer">
					<video src="{@$image->getVideoLink()}"{if $image->hasVideoThumbnail()} poster="{@$image->getURL()}"{/if} controls></video>
				</div>
			</div>
		{elseif $image->isVideoLink}
			<div class="galleryVideoContainer">
				<div class="videoContainer">
					{@$image->getVideoLinkEmbedCode()}
				</div>
			</div>
		{else}
			{if $image->albumID}
				<a class="jsGalleryAlbumImageViewer" data-object-id="{@$image->albumID}" data-target-image-id="{@$image->imageID}" data-disable-slideshow="true">
			{else}
				<a class="jsGalleryUserImageViewer" data-object-id="{@$image->userID}" data-target-image-id="{@$image->imageID}" data-disable-slideshow="true">
			{/if}
				{if $image->largeThumbnailSize}
					{@$image->getLargeThumbnail()}
				{else}
					{@$image->getImageTag()}
				{/if}
			</a>
		{/if}
	</div>
	
	{hascontent}
		<div class="section">
			<div class="htmlContent">
				{content}{@$image->getFormattedMessage()}{/content}
			</div>
		</div>
	{/hascontent}
	
	{if $image->getDeleteNote()}
		<div class="section">
			<p class="galleryImageDeleteNote">{@$image->getDeleteNote()}</p>
		</div>
	{/if}
	
	{if MODULE_LIKE && $imageLikeData|isset}
		<div class="galleryImageLikesSummery section">
			{include file="reactionSummaryList" reactionData=$imageLikeData objectType="com.woltlab.gallery.likeableImage" objectID=$image->imageID}
		</div>
	{/if}
	
	<div class="section">
		<ul id="imageButtonContainer" class="galleryImageButtons buttonGroup buttonList smallButtons jsImageInlineEditorContainer" data-object-id="{@$image->imageID}" data-is-deleted="{@$image->isDeleted}" data-is-disabled="{@$image->isDisabled}" data-can-delete-image="{@$image->canDelete()}" data-can-edit-image="{@$image->canEdit()}" data-can-moderate-image="{@$__wcf->session->getPermission('mod.gallery.canModerateImage')}">
			{if $image->canEdit()}
				<li><a href="{link application='gallery' controller='ImageEdit' id=$image->imageID}{/link}" class="button jsImageInlineEditor" title="{lang}gallery.image.edit{/lang}"><span class="icon icon16 fa-pencil"></span> <span>{lang}wcf.global.button.edit{/lang}</span></a></li>
			{/if}
			<li><a href="{$image->getLink()}" class="button jsButtonShare jsOnly" data-link-title="{$image->title}"><span class="icon icon16 fa-share-alt"></span> <span>{lang}wcf.message.share{/lang}</span></a></li>
			{if $__wcf->session->getPermission('user.profile.canReportContent')}
				<li class="jsReportImage jsOnly" data-object-id="{@$image->imageID}"><a href="#" title="{lang}wcf.moderation.report.reportContent{/lang}" class="button jsTooltip"><span class="icon icon16 fa-exclamation-triangle"></span> <span class="invisible">{lang}wcf.moderation.report.reportContent{/lang}</span></a></li>
			{/if}
			{if MODULE_USER_INFRACTION && $userProfile->userID && $__wcf->session->getPermission('mod.infraction.warning.canWarn') && !$userProfile->getPermission('mod.infraction.warning.immune')}
				<li class="jsWarnImage jsOnly" data-object-id="{@$image->imageID}" data-user-id="{@$userProfile->userID}"><a href="#" title="{lang}wcf.infraction.warn{/lang}" class="button jsTooltip"><span class="icon icon16 fa-gavel"></span> <span class="invisible">{lang}wcf.infraction.warn{/lang}</span></a></li>
			{/if}
			{if $__wcf->getUser()->userID}
				<li><a href="#" class="jsGalleryFavoriteButton jsTooltip button{if $image->isFavorite()} active{/if}" data-object-id="{@$image->imageID}" title="{lang}gallery.image.favorite.{if $image->isFavorite()}remove{else}add{/if}{/lang}"><span class="icon icon16 fa-star"></span> <span class="invisible">{lang}gallery.image.favorite.{if $image->isFavorite()}remove{else}add{/if}{/lang}</span></a></li>
			{/if}
			{if $image->canReact()}
				<li><a href="#" class="reactButton jsTooltip button{if $imageLikeData[$image->imageID]|isset && $imageLikeData[$image->imageID]->reactionTypeID} active{/if}" title="{lang}wcf.reactions.react{/lang}" data-reaction-type-id="{if $imageLikeData[$image->imageID]|isset && $imageLikeData[$image->imageID]->reactionTypeID}{$imageLikeData[$image->imageID]->reactionTypeID}{else}0{/if}"><span class="icon icon16 fa-smile-o"></span> <span class="invisible">{lang}wcf.reactions.react{/lang}</span></a></li>
			{/if}
			
			{event name='imageButtons'}
		</ul>
	</div>
</div>

{if ENABLE_SHARE_BUTTONS}
	{capture assign='footerBoxes'}
		<section class="box boxFullWidth jsOnly">
			<h2 class="boxTitle">{lang}wcf.message.share{/lang}</h2>
			
			<div class="boxContent">
				{include file='shareButtons'}
			</div>
		</section>
	{/capture}
{/if}

{event name='imageAfter'}

{if $image->enableComments}
	{if $commentList|count || $commentCanAdd}
		<section id="comments" class="section sectionContainerList">
			<header class="sectionHeader">
				<h2 class="sectionTitle">{lang}gallery.image.comments{/lang}{if $image->comments} <span class="badge">{#$image->comments}</span>{/if}</h2>
			</header>
		
			{include file='__commentJavaScript' commentContainerID='galleryImageCommentList'}
			
			<div class="galleryImageComments">
				<ul id="galleryImageCommentList" class="commentList containerList" data-can-add="{if $commentCanAdd}true{else}false{/if}" data-object-id="{@$imageID}" data-object-type-id="{@$commentObjectTypeID}" data-comments="{if $image->comments}{@$commentList->countObjects()}{else}0{/if}" data-last-comment-time="{@$lastCommentTime}">
					{if $commentCanAdd}{include file='commentListAddComment' wysiwygSelector='galleryImageCommentListAddComment'}{/if}
					{include file='commentList'}
				</ul>
			</div>
		</section>
	{/if}
{/if}

<script data-relocate="true" src="{@$__wcf->getPath()}js/WCF.Infraction{if !ENABLE_DEBUG_MODE}.min{/if}.js?v={@LAST_UPDATE_TIME}"></script>
{if GOOGLE_MAPS_API_KEY && $image->latitude != 0.0 && $image->longitude != 0.0}
	{include file='googleMapsJavaScript'}
{/if}
<script data-relocate="true">
	$(function() {
		WCF.Language.addObject({
			'gallery.image.delete': '{jslang}gallery.image.delete{/jslang}',
			'gallery.image.delete.confirmMessage': '{jslang}gallery.image.delete.confirmMessage{/jslang}',
			'gallery.image.delete.success': '{jslang}gallery.image.delete.success{/jslang}',
			'gallery.image.disable': '{jslang}gallery.image.disable{/jslang}',
			'gallery.image.enable': '{jslang}gallery.image.enable{/jslang}',
			'gallery.image.isDeleted': '{jslang}gallery.image.isDeleted{/jslang}',
			'gallery.image.isDisabled': '{jslang}gallery.image.isDisabled{/jslang}',
			'gallery.image.marker': '{jslang}gallery.image.marker{/jslang}',
			'gallery.image.restore': '{jslang}gallery.image.restore{/jslang}',
			'gallery.image.trash': '{jslang}gallery.image.trash{/jslang}',
			'gallery.image.trash.confirmMessage': '{jslang}gallery.image.trash.confirmMessage{/jslang}',
			'gallery.image.trash.reason': '{jslang}gallery.image.trash.reason{/jslang}',
			'gallery.image.share.smallImage': '{jslang}gallery.image.share.smallImage{/jslang}',
			'gallery.image.share.largeImage': '{jslang}gallery.image.share.largeImage{/jslang}',
			'wcf.message.share': '{jslang}wcf.message.share{/jslang}',
			'wcf.message.share.permalink': '{jslang}wcf.message.share.permalink{/jslang}',
			'wcf.message.share.permalink.bbcode': '{jslang}wcf.message.share.permalink.bbcode{/jslang}',
			'wcf.message.share.permalink.html': '{jslang}wcf.message.share.permalink.html{/jslang}',
			'wcf.moderation.report.reportContent': '{jslang}wcf.moderation.report.reportContent{/jslang}',
			'wcf.moderation.report.success': '{jslang}wcf.moderation.report.success{/jslang}',
			'wcf.infraction.warn': '{jslang}wcf.infraction.warn{/jslang}',
			'wcf.infraction.warn.success': '{jslang}wcf.infraction.warn.success{/jslang}',
			'wcf.message.bbcode.code.copy': '{jslang}wcf.message.bbcode.code.copy{/jslang}'
		});
		
		var $updateHandler = new Gallery.Image.UpdateHandler.Image();
		
		var $inlineEditor = new Gallery.Image.InlineEditor('.jsImageInlineEditorContainer');
		$inlineEditor.setRedirectURL('{link application='gallery' controller='ImageList' encode=false}{/link}', 'image');
		$inlineEditor.setUpdateHandler($updateHandler);
		
		$inlineEditor.setPermissions({
			canDeleteImage: {if $image->canDelete()}true{else}false{/if},
			canEnableImage: {if $image->canEnable()}true{else}false{/if},
			canRestoreImage: {if $image->canRestore()}true{else}false{/if},
			canTrashImage: {if $image->canTrash()}true{else}false{/if},
			canViewDeletedImage: {if $__wcf->session->getPermission('mod.gallery.canViewDeletedImage')}true{else}false{/if}
		});
		
		{if $__wcf->session->getPermission('user.profile.canReportContent')}
			new WCF.Moderation.Report.Content('com.woltlab.gallery.image', '.jsReportImage');
		{/if}
		
		{if MODULE_USER_INFRACTION && $__wcf->session->getPermission('mod.infraction.warning.canWarn')}
			new WCF.Infraction.Warning.Content('com.woltlab.gallery.warnableImage', '.jsWarnImage');
		{/if}
		
		new Gallery.Image.Share({@$image->imageID}, '{if $image->smallThumbnailSize}{$image->getURL('small')}{/if}', '{if $image->largeThumbnailSize}{$image->getURL('large')}{else}{$image->getURL()}{/if}');
		
		{if GOOGLE_MAPS_API_KEY && $image->latitude != 0.0 && $image->longitude != 0.0}
			var $map = new WCF.Location.GoogleMaps.Map('imageMap');
			WCF.Location.GoogleMaps.Util.focusMarker($map.addMarker({@$image->latitude}, {@$image->longitude}, '{$image->title|encodeJS}'));
		{/if}
		
		{if $image->getAlbum() && $albumImageList|count > 3}
			new Gallery.Image.AlbumNavigation();
		{/if}
		
		Gallery.Image.Slideshow.init();
		
		{if $image->hasMarkers}
			var $markers = [ ];
			{foreach from=$image->getMarkers() item=marker}
				$markers.push({
					description: '{@$marker->getDescription()|encodeJS}',
					markerID: {@$marker->markerID},
					positionX: {@$marker->positionX},
					positionY: {@$marker->positionY},
					userID: {if $marker->userID}{@$marker->userID}{else}null{/if}
				});
			{/foreach}
			
			new Gallery.Image.Marker.Handler($markers, {@$image->width}, {@$image->height});
			
			new Gallery.Image.Marker.TextPopover();
		{/if}
	});
	
	require(
		['Language', 'WoltLabSuite/Gallery/Ui/Image/Favorite/Handler', 'WoltLabSuite/Core/Ui/Reaction/Handler'],
		function(Language, UiImageFavoriteHandler, UiReactionHandler) {
			Language.addObject({
				'gallery.image.favorite.add': '{jslang}gallery.image.favorite.add{/jslang}',
				'gallery.image.favorite.remove': '{jslang}gallery.image.favorite.remove{/jslang}'
			});
			
			new UiReactionHandler('com.woltlab.gallery.likeableImage', {
				// settings
				isSingleItem: true,
				
				// selectors
				containerSelector: '.galleryImageContainer',
				buttonSelector: '#imageButtonContainer .reactButton',
				summaryListSelector: '.galleryImageContainer .galleryImageLikesSummery .reactionSummaryList'
			});
			
			new UiImageFavoriteHandler();
		}
	);
</script>

{include file='footer'}
