{foreach from=$objects item=album}
	<li>
		<div class="box32">
			<div class="containerHeadline">
				<h3><a href="{link application='gallery' controller='Album' object=$album}{/link}">{$album->title}</a></h3>
				<ul class="inlineList dotSeparated small">
					{lang}gallery.album.info{/lang}
				</ul>
			</div>
		</div>
		
		{hascontent}
			{assign var=__albumCoverImages value=$album->getCoverImages()}
			{assign var=__firstAlbumCoverImage value=$__albumCoverImages|reset}
			<ul class="galleryAlbumCoverImages{if !$__albumCoverImages|empty && $__firstAlbumCoverImage->mediumThumbnailSize} galleryMediumAlbumCoverImages{/if}">
				{content}
					{foreach from=$album->getCoverImages() item=image name=coverImages}
						{if $tpl[foreach][coverImages][first] && $image->mediumThumbnailSize}
							<li><a href="{link application='gallery' controller='Album' object=$album}{/link}">{@$image->getMediumThumbnail()}</a></li>
						{elseif $image->tinyThumbnailSize}
							<li><a href="{link application='gallery' controller='Album' object=$album}{/link}">{@$image->getTinyThumbnail()}</a></li>
						{/if}
					{/foreach}
				{/content}
			</ul>
		{/hascontent}
	</li>
{/foreach}
