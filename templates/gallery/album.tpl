{capture assign='pageTitle'}{$album->title}{if $pageNo > 1} - {lang}wcf.page.pageNo{/lang}{/if}{/capture}

{capture assign='contentTitle'}{$album->title}{if $items} <span class="badge">{#$items}</span>{/if}{/capture}

{capture assign='contentDescription'}
	{if !$album->hasEveryoneAccessLevel()}<small>{lang}gallery.album.accessLevel.info{/lang}</small><br>{/if}
	{$album->description}
{/capture}

{capture assign='contentHeaderNavigation'}
	{if $objects|count && $enableEditMode}
		<li class="jsOnly"><button class="jsButtonGalleryMarkAll"><span class="icon icon16 fa-check"></span> <span>{lang}gallery.image.button.markAll{/lang}</span></button></li>
	{/if}
	
	{if $album->canEdit()}
		<li class="jsOnly"><a class="button jsAlbumInlineEditor"><span class="icon icon16 fa-pencil"></span> <span>{lang}gallery.album.edit{/lang}</span></a></li>
	{/if}
	
	{if $showImageViewer}
		<li class="jsOnly"><span class="button jsGalleryAlbumImageViewer" data-object-id="{@$album->albumID}"><span class="icon icon16 fa-play"></span> <span>{lang}wcf.imageViewer.button.openSlideshow{/lang}</span></span></li>
	{/if}
	
	{if $album->canAdd()}
		<li><a href="{link application='gallery' controller='ImageAdd'}albumID={@$album->albumID}{/link}" class="button buttonPrimary"><span class="icon icon16 fa-plus"></span> <span>{lang}gallery.image.button.upload{/lang}</span></a></li>
	{/if}
{/capture}

{include file='header'}

{if $album->hasOwnerAccessLevel() && !$album->canAdd()}
	<p class="info" role="status">{lang}gallery.album.ownerImageModerationWarning{/lang}</p>
{/if}

{hascontent}
	<div class="paginationTop">
		{content}{pages print=true assign=pagesLinks application='gallery' controller='Album' object=$album link="pageNo=%d&sortField=$sortField&sortOrder=$sortOrder"}{/content}
	</div>
{/hascontent}

{if $items}
	<div class="section galleryImageListContainer">
		<div class="containerListDisplayOptions">
			<div class="containerListSortOptions">
				<a rel="nofollow" href="{link application='gallery' controller='Album' object=$album}pageNo={@$pageNo}&sortField={$sortField}&sortOrder={if $sortOrder === 'ASC'}DESC{else}ASC{/if}{/link}">
					<span class="icon icon16 fa-sort-amount-{$sortOrder|strtolower} jsTooltip" title="{lang}gallery.image.button.sort{/lang} ({lang}wcf.global.sortOrder.{if $sortOrder === 'ASC'}ascending{else}descending{/if}{/lang})"></span>
				</a>
				<span class="dropdown">
					<span class="dropdownToggle">{lang}gallery.image.sortField.{$sortField}{/lang}</span>
					
					<ul class="dropdownMenu">
						{foreach from=$validSortFields item=_sortField}
							<li{if $_sortField === $sortField} class="active"{/if}><a rel="nofollow" href="{link application='gallery' controller='Album' object=$album}pageNo={@$pageNo}&sortField={$_sortField}&sortOrder={if $sortField === $_sortField}{if $sortOrder === 'DESC'}ASC{else}DESC{/if}{else}{$sortOrder}{/if}{/link}">{lang}gallery.image.sortField.{$_sortField}{/lang}</a></li>
						{/foreach}
					</ul>
				</span>
			</div>
		</div>
		
		{include file='imageListItems' application='gallery'}
	</div>
{else}
	<p class="info" role="status">{lang}wcf.global.noItems{/lang}</p>
{/if}

<footer class="contentFooter">
	{hascontent}
		<div class="paginationBottom">
			{content}{@$pagesLinks}{/content}
		</div>
	{/hascontent}
	
	{hascontent}
		<nav class="contentFooterNavigation">
			<ul>
				{content}
					<li><a href="{link application='gallery' controller='Album' object=$album}{/link}" class="button jsButtonShare jsOnly" data-link-title="{$album->title}"><span class="icon icon16 fa-share-alt"></span> <span>{lang}wcf.message.share{/lang}</span></a></li>
					
					{event name='contentFooterNavigation'}
				{/content}
			</ul>
		</nav>
	{/hascontent}
</footer>

{capture assign='footerBoxes'}
	{if ENABLE_SHARE_BUTTONS}
		<section class="box boxFullWidth jsOnly">
			<h2 class="boxTitle">{lang}wcf.message.share{/lang}</h2>
			
			<div class="boxContent">
				{include file='shareButtons'}
			</div>
		</section>
	{/if}
{/capture}

{if GOOGLE_MAPS_API_KEY && $mapBounds !== null && $items}
	{include file='googleMapsJavaScript'}
{/if}

<script data-relocate="true">
	$(function() {
		WCF.Language.addObject({
			'gallery.album.delete': '{jslang}gallery.album.delete{/jslang}',
			'gallery.album.delete.confirmMessage': '{jslang}gallery.album.delete.confirmMessage{/jslang}',
			'gallery.album.delete.success': '{jslang}gallery.album.delete.success{/jslang}',
			'gallery.album.edit': '{jslang}gallery.album.edit{/jslang}',
			'gallery.album.sortImages': '{jslang}gallery.album.sortImages{/jslang}',
			'gallery.image.delete': '{jslang}gallery.image.delete{/jslang}',
			'gallery.image.delete.confirmMessage': '{jslang}gallery.image.delete.confirmMessage{/jslang}',
			'gallery.image.delete.success': '{jslang}gallery.image.delete.success{/jslang}',
			'gallery.image.disable': '{jslang}gallery.image.disable{/jslang}',
			'gallery.image.enable': '{jslang}gallery.image.enable{/jslang}',
			'gallery.image.moveToAlbum': '{jslang}gallery.image.moveToAlbum{/jslang}',
			'gallery.image.restore': '{jslang}gallery.image.restore{/jslang}',
			'gallery.image.trash': '{jslang}gallery.image.trash{/jslang}',
			'gallery.image.trash.confirmMessage': '{jslang}gallery.image.trash.confirmMessage{/jslang}',
			'gallery.image.trash.reason': '{jslang}gallery.image.trash.reason{/jslang}',
			'wcf.message.share': '{jslang}wcf.message.share{/jslang}',
			'wcf.message.share.permalink': '{jslang}wcf.message.share.permalink{/jslang}',
			'wcf.message.share.permalink.bbcode': '{jslang}wcf.message.share.permalink.bbcode{/jslang}',
			'wcf.message.share.permalink.html': '{jslang}wcf.message.share.permalink.html{/jslang}'
		});
		
		{if $album->canEdit()}
			$('.contentHeaderNavigation').data('albumID', {@$album->albumID});
			var $albumInlineEditor = new Gallery.Album.InlineEditor('.contentHeaderNavigation');
			$albumInlineEditor.setPermissions({
				canDeleteAlbum: {if $album->canDelete()}1{else}0{/if},
				canEditAlbum: {if $album->canEdit()}1{else}0{/if},
				canSortImages: {if $album->canEdit() && $items}1{else}0{/if}
			});
			$albumInlineEditor.setRedirectURL('{link controller='UserAlbumList' object=$__wcf->user application='gallery' encode=false}{/link}');
			$albumInlineEditor.setSortImagesURL('{link controller='AlbumImageSort' object=$album application='gallery' encode=false}{/link}');
		{/if}
		
		{if $enableEditMode}
			var $updateHandler = new Gallery.Image.UpdateHandler.ImageList();
			
			var $imageInlineEditor = new Gallery.Image.InlineEditor('.galleryImage');
			$imageInlineEditor.setRedirectURL('{link application='gallery' controller='ImageList' encode=false}{/link}');
			$imageInlineEditor.setUpdateHandler($updateHandler);
			
			new Gallery.Image.Clipboard($updateHandler);
			WCF.Clipboard.init('gallery\\page\\AlbumPage', {@$hasMarkedItems});
			
			$imageInlineEditor.setPermissions({
				canDeleteImage: {@$__wcf->session->getPermission('mod.gallery.canDeleteImageCompletely')},
				canEnableImage: {@$__wcf->session->getPermission('mod.gallery.canModerateImage')},
				canRestoreImage: {@$__wcf->session->getPermission('mod.gallery.canRestoreImage')},
				canTrashImage: {@$__wcf->session->getPermission('mod.gallery.canDeleteImage')}
			});
		{/if}
		
		{if $showImageViewer}
			Gallery.Image.Slideshow.init();
		{/if}
		
		new Gallery.Album.Share({@$album->albumID});
		
		{if $mapBounds !== null && $items}
			var $albumMap = new Gallery.Map.LargeMap('albumMap', { }, 'gallery\\data\\image\\ImageAction', '#geocode', { albumID: {@$album->albumID} });
			$albumMap.setBounds({
				latitude: {@$mapBounds[northEast].latitude},
				longitude: {@$mapBounds[northEast].longitude}
			}, {
				latitude: {@$mapBounds[southWest].latitude},
				longitude: {@$mapBounds[southWest].longitude}
			});
		{/if}
		
		{event name='javascriptInit'}
	});
</script>

{include file='footer'}
