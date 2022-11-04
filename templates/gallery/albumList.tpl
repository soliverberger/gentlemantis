{if $didSearch}
	{capture assign='pageTitle'}{lang}gallery.album.search.results{/lang}{if $pageNo > 1} - {lang}wcf.page.pageNo{/lang}{/if}{/capture}
	{capture assign='contentTitle'}{lang}gallery.album.search.results{/lang}{/capture}
{elseif $controllerName === 'AlbumList'}
	{capture assign='pageTitle'}{$__wcf->getActivePage()->getTitle()}{if $pageNo > 1} - {lang}wcf.page.pageNo{/lang}{/if}{/capture}
	{capture assign='contentTitle'}{$__wcf->getActivePage()->getTitle()}{/capture}
{elseif $controllerName === 'UserAlbumList'}
	{capture assign='pageTitle'}{lang}gallery.album.userAlbums{/lang}{if $pageNo > 1} - {lang}wcf.page.pageNo{/lang}{/if}{/capture}
	{capture assign='contentTitle'}{lang}gallery.album.userAlbums{/lang}{/capture}
{elseif $controllerName === 'UnreadAlbumList'}
	{capture assign='pageTitle'}{lang}gallery.album.unreadAlbums{/lang}{if $pageNo > 1} - {lang}wcf.page.pageNo{/lang}{/if}{/capture}
	{capture assign='contentTitle'}{lang}gallery.album.unreadAlbums{/lang}{/capture}
{else}
	{capture assign='pageTitle'}{lang}gallery.album.albums{/lang}{if $pageNo > 1} - {lang}wcf.page.pageNo{/lang}{/if}{/capture}
{/if}

{assign var='linkParameters' value=''}
{if $category}{capture append='linkParameters'}&categoryID={@$category->categoryID}{/capture}{/if}
{if $albumTitle}{capture append='linkParameters'}&albumTitle={@$albumTitle|rawurlencode}{/capture}{/if}
{capture assign='headContent'}
	{if !$feedControllerName|empty}
		{if $__wcf->getUser()->userID}
			<link rel="alternate" type="application/rss+xml" title="{lang}wcf.global.button.rss{/lang}" href="{link application='gallery' controller=$feedControllerName object=$controllerObject}at={@$__wcf->getUser()->userID}-{@$__wcf->getUser()->accessToken}{/link}">
		{else}
			<link rel="alternate" type="application/rss+xml" title="{lang}wcf.global.button.rss{/lang}" href="{link application='gallery' controller=$feedControllerName object=$controllerObject}{/link}">
		{/if}
	{/if}
	{if $pageNo < $pages}
		<link rel="next" href="{link application='gallery' controller=$controllerName object=$controllerObject}pageNo={@$pageNo+1}{@$linkParameters}{/link}">
	{/if}
	{if $pageNo > 1}
		<link rel="prev" href="{link application='gallery' controller=$controllerName object=$controllerObject}{if $pageNo > 2}pageNo={@$pageNo-1}{@$linkParameters}{else}{@$linkParameters|substr:1}{/if}{/link}">
	{/if}
	<link rel="canonical" href="{link application='gallery' controller=$controllerName object=$controllerObject}{if $pageNo > 1}pageNo={@$pageNo}{/if}{/link}">
{/capture}

{capture assign='headerNavigation'}
	{if !$feedControllerName|empty}
		<li><a rel="alternate" href="{if $__wcf->getUser()->userID}{link application='gallery' controller=$feedControllerName object=$controllerObject}at={@$__wcf->getUser()->userID}-{@$__wcf->getUser()->accessToken}{/link}{else}{link application='gallery' controller=$feedControllerName object=$controllerObject}{/link}{/if}" title="{lang}wcf.global.button.rss{/lang}" class="jsTooltip"><span class="icon icon16 fa-rss"></span> <span class="invisible">{lang}wcf.global.button.rss{/lang}</span></a></li>
	{/if}
	{if $controllerName === 'UnreadAlbumList'}
		<li class="jsOnly"><a href="#" title="{lang}gallery.image.markAllAsRead{/lang}" class="markAllAsReadButton jsTooltip"><span class="icon icon16 fa-check"></span> <span class="invisible">{lang}gallery.image.markAllAsRead{/lang}</span></a></li>
	{/if}
{/capture}

{capture assign='contentHeaderNavigation'}
	{if $canAddAlbum}
		<li class="jsOnly"><a href="#" id="albumAddButton" class="button"><span class="icon icon16 fa-plus"></span> <span>{lang}gallery.album.add{/lang}</span></a></li>
	{/if}
	
	{if $__gallery->canAdd()}
		<li><a href="{link application='gallery' controller='ImageAdd'}{/link}" class="button buttonPrimary"><span class="icon icon16 fa-plus"></span> <span>{lang}gallery.image.button.upload{/lang}</span></a></li>
	{/if}
{/capture}

{capture assign='boxesContentTop'}
	<section class="box">
		<form method="post" action="{link application='gallery' controller=$controllerName object=$controllerObject}{/link}">
			<h2 class="boxTitle">{lang}gallery.album.search{/lang}</h2>
			
			<div class="boxContent">
				<dl>
					<dt></dt>
					<dd>
						<input type="text" id="albumTitle" name="albumTitle" class="long" placeholder="{lang}wcf.global.title{/lang}" value="{$albumTitle}">
					</dd>
				</dl>
			</div>
			
			<div class="formSubmit">
				<input type="hidden" name="categoryID" value="{@$categoryID}">
				<input type="hidden" name="sortField" value="{@$sortField}">
				<input type="hidden" name="sortOrder" value="{@$sortOrder}">
				<input type="submit" value="{lang}wcf.global.button.submit{/lang}" accesskey="s">
			</div>
		</form>
	</section>
{/capture}

{include file='header'}

{hascontent}
	<div class="paginationTop">
		{content}
			{pages print=true assign=pagesLinks application='gallery' controller=$controllerName object=$controllerObject link="pageNo=%d&sortField=$sortField&sortOrder=$sortOrder$linkParameters"}
		{/content}
	</div>
{/hascontent}

{if $items}
	<div class="section sectionContainerList">
		<div class="containerListDisplayOptions">
			<div class="containerListSortOptions">
				<a rel="nofollow" href="{link application='gallery' controller=$controllerName object=$controllerObject}pageNo={@$pageNo}&sortField={$sortField}&sortOrder={if $sortOrder == 'ASC'}DESC{else}ASC{/if}{if $categoryID}&categoryID={@$categoryID}{/if}{if $albumTitle}&albumTitle={@$albumTitle|rawurlencode}{/if}{/link}">
					<span class="icon icon16 fa-sort-amount-{$sortOrder|strtolower} jsTooltip" title="{lang}wcf.global.sorting{/lang} ({lang}wcf.global.sortOrder.{if $sortOrder === 'ASC'}ascending{else}descending{/if}{/lang})"></span>
				</a>
				<span class="dropdown">
					<span class="dropdownToggle">
						{if $sortField == 'title'}
							{lang}wcf.global.title{/lang}
						{elseif $sortField == 'images'}
							{lang}gallery.image.images{/lang}
						{else}
							{lang}gallery.album.{$sortField}{/lang}
						{/if}
					</span>
					
					<ul class="dropdownMenu">
						{foreach from=$validSortFields item=_sortField}
							<li{if $_sortField === $sortField} class="active"{/if}><a rel="nofollow" href="{link application='gallery' controller=$controllerName object=$controllerObject}pageNo={@$pageNo}&sortField={$_sortField}&sortOrder={if $sortField === $_sortField}{if $sortOrder === 'DESC'}ASC{else}DESC{/if}{else}{$sortOrder}{/if}{if $categoryID}&categoryID={@$categoryID}{/if}{if $albumTitle}&albumTitle={@$albumTitle|rawurlencode}{/if}{/link}">
								{if $_sortField == 'title'}
									{lang}wcf.global.title{/lang}
								{elseif $_sortField == 'images'}
									{lang}gallery.image.images{/lang}
								{else}
									{lang}gallery.album.{$_sortField}{/lang}
								{/if}
							</a></li>
						{/foreach}
					</ul>
				</span>
			</div>
		</div>
		
		<ul class="containerList galleryAlbumList">
			{include file='albumListItems' application='gallery'}
		</ul>
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
					{event name='contentFooterNavigation'}
				{/content}
			</ul>
		</nav>
	{/hascontent}
</footer>

{if $canAddAlbum}
	<script data-relocate="true">
		$(function() {
			WCF.Language.addObject({
				'gallery.album.add': '{jslang}gallery.album.add{/jslang}'
			});
			
			var $albumDialog = new Gallery.Album.Dialog();
			
			$('#albumAddButton').click(function(event) {
				event.preventDefault();
				$albumDialog.show();
			});
			
			$albumDialog.registerCallback('created', function(data) {
				{event name='created'}
				
				window.location = data.link;
			});
			
			{if $controllerName === 'UnreadAlbumList'}
				new Gallery.Category.MarkAllAsRead();
			{/if}
			
			{event name='javascriptInit'}
		});
	</script>
{/if}

{include file='footer'}
