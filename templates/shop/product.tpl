{capture assign='pageTitle'}{$product->getTitle()} - {$category->getTitle()}{/capture}

{capture assign='contentHeader'}
	<header class="contentHeader">
		<div class="contentHeaderTitle">
			<h1 class="contentTitle">{$product->getTitle()}</h1>
			<p class="contentHeaderDescription">
				{if $product->getLabel()}{@$product->getLabel()}{/if}

				{if $product->inventory !== null}
					{if $product->inventory > 0}
						<span class="badge productInventoryBadge green">{lang}shop.product.inventory.status.available{/lang}</span>
					{elseif $product->inventoryReorder > 0}
						<span class="badge productInventoryBadge orange">{lang}shop.product.inventory.status.reorder{/lang}</span>
					{elseif $product->inventory == 0}
						<span class="badge productInventoryBadge red">{lang}shop.product.inventory.status.notAvailable{/lang}</span>
					{/if}
				{/if}


				{if $product->isSpecialOfferActive()}
					<span class="badge productSpecialPriceBadge green">
						{if $product->specialOfferName}{lang}{$product->specialOfferName}{/lang}: {/if}
						{include file='__productItemPrice' application='shop'}
					</span>
				{/if}
			</p>
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

{include file='header'}

{include file='currencySelection' application='shop'}

{if $product->isSpecialOfferActive()}
	{hascontent}
		<div class="info shopSpecialOfferInfo">
			<h3>{lang}{$product->specialOfferName}{/lang}</h3>
			{content}
				{lang}{$product->specialOfferDescription}{/lang}
			{/content}
		</div>
	{/hascontent}
{/if}

{if $product->getStatus() == "alreadyPurchased"}
	<p class="info">{lang}shop.product.status.alreadyPurchased{/lang}</p>
{/if}

<div id="product{@$product->productID}" class="shopProduct section">
	<div class="shopProductText clearfix">
		<div class="shopProductImage">
			<div>
				<img src="{@$product->getPreviewImage()}" alt=""/>
			</div>

			{if $product->isAvailableForPurchase()}
				<a href="{link application='shop' controller='ProductOrder' object=$product}{/link}" class="button buttonPrimary">
					<span>
						{@$product->getOrderLabel()}

						{if $product->showOrderButtonPrice}
							<small>
								({include file='__productItemPrice' application='shop' hideSpecialOffer=1})
							</small>
						{/if}
					</span>
				</a>
			{/if}

			{if $product->getAdditionalButtons()|count > 0}
				<div class="section">
					<ul class="buttonList smallButtons">
						{foreach from=$product->getAdditionalButtons() item=$link}
							<li><a class="button small" href="{@$link['url']}">{$link['label']}</a></li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{event name='afterOrderButton'}
		</div>

		<div class="htmlContent">
			{@$product->getDescription()}
			
			{hascontent}
				<section class="section">
					{content}{@$product->getProductType()->fetchProductTemplate($product)}{/content}
				</section>
			{/hascontent}
		</div>
	</div>

	{event name='productText'}

	{if $product->getScreenshotList()|count}
		{if $product->getHeroImage()->showAsImage() && $product->getHeroImage()->width > 400}
			<div class="shopProductSection shopProductImageHeroContainer framed">
				<img src="{link controller='Attachment' object=$product->getHeroImage()}{/link}" alt=""
				     class="shopProductImageHero"/>
			</div>
		{/if}

		{if $product->getScreenshotList()|count > 1}
			{hascontent}
				<section class="section shopProductSection productScreenshotImageNavigation">

					<ul>
						<li class="productNavigationArrow productNavigationArrowPrevious{if $product->getScreenshotList()|count <= 2} disabled{/if}">
							<span class="icon icon16 fa-arrow-left{if $product->getScreenshotList()|count > 2} pointer{/if}"></span>
						</li>
						<li>
							<ul id="productScreenshotNavigation">
								{content}
								{foreach from=$product->getScreenshotList() item=attachment}
									{if $attachment->showAsImage()}
										<li{if $attachment->attachmentID == $product->getHeroImage()->attachmentID} class="active"{/if}>
											{if $attachment->hasThumbnail()}
												<a href="{link controller='Attachment' object=$attachment}{/link}"{if $attachment->canDownload()} class="jsImageViewer" title="{$attachment->filename}"{/if}><img
														src="{link controller='Attachment' object=$attachment}thumbnail=1{/link}"
														alt=""
														style="{if $attachment->thumbnailHeight < ATTACHMENT_THUMBNAIL_HEIGHT}margin-top: {@ATTACHMENT_THUMBNAIL_HEIGHT/2-$attachment->thumbnailHeight/2}px; {/if}{if $attachment->thumbnailWidth < ATTACHMENT_THUMBNAIL_WIDTH}margin-left: {@ATTACHMENT_THUMBNAIL_WIDTH/2-$attachment->thumbnailWidth/2}px{/if}"/></a>
											{else}
												<img src="{link controller='Attachment' object=$attachment}{/link}"
												     alt=""
												     style="margin-top: {@ATTACHMENT_THUMBNAIL_HEIGHT/2-$attachment->height/2}px; margin-left: {@ATTACHMENT_THUMBNAIL_WIDTH/2-$attachment->width/2}px"/>
											{/if}
										</li>
									{/if}
								{/foreach}
								{/content}
							</ul>
						</li>
						<li class="productNavigationArrow productNavigationArrowNext{if $product->getScreenshotList()|count <= 2} disabled{/if}">
							<span class="icon icon16 fa-arrow-right{if $product->getScreenshotList()|count > 2} pointer{/if}"></span>
						</li>
					</ul>
				</section>

				<script data-relocate="true">
                    require(['VieCode/Shop/Ui/Product/Screenshot'], function (ProductScreenshotNavigation) {
                        ProductScreenshotNavigation.init('.productScreenshotImageNavigation', '#productScreenshotNavigation', 1, {$product->getScreenshotList()|count}, 0);
                    });
				</script>
			{/hascontent}
		{/if}
	{/if}

	<div class="row">
		{if $product->getFunctionList()|count}
			<div class="col-md-6 col-xs-12">
				<div class="section">
					<h2 class="sectionTitle">{lang}shop.product.functions{/lang}</h2>

					<ul class="shopProductFunctionList">
						{foreach from=$product->getFunctionList() item=$function}
							<li class="box16">
								<a href="{link controller='ProductFunction' application='shop' object=$product}#f{@$function->functionID}{/link}" class="productFunctionLink" data-function-id="{@$function->functionID}">
									<span class="icon icon16 {@$function->getIcon()}"></span>
									<span>{$function->title|language}</span>
								</a>
							</li>
						{/foreach}
					</ul>
				</div>
			</div>
		{/if}

		{if SHOP_MODULE_PRODUCTS_REVIEW && $product->canViewReview() && $reviewList|count}
			<div class="col-md-6 col-xs-12 customerProductSectionReview">
				<div class="section">
					<h2 class="sectionTitle">{lang}shop.product.review.rating.average{/lang}</h2>

					{include file='productReviewSummary' application='shop'}


					<nav class="contentNavigation">
						<ul class="buttonList smallButtons">
							<li>
								<a class="button small" href="{link controller='ProductReview' application='shop' object=$product}{/link}">
									<span>{lang}shop.product.button.review{/lang}</span>
								</a>
							</li>
						</ul>
					</nav>

				</div>
			</div>
		{/if}

		{event name='subContainerContent'}
	</div>

	{hascontent}
		<div class="shopProductSection shopProductSectionNote">
			<small>{content}{include file='__taxInformation' application='shop' tax=$product->getTax() shipping=$product->getProductType()->isShippingItem() sandbox=true}{/content}</small>
		</div>
	{/hascontent}

	{event name='product'}

	<div class="contentNavigation">
		<nav>
			<ul>
				<li>
					<a href="{link application='shop' controller='Product' object=$product appendSession=false}{/link}" class="button jsButtonShare jsOnly" data-link-title="{$product->getTitle()}">
						<span class="icon icon16 fa-link"></span>
						<span>{lang}wcf.message.share{/lang}</span>
					</a>
				</li>
				<li>
					<a href="" class="button jsProductBBCodeShare jsOnly" data-product-id="{$product->productID}">
						<span class="icon icon16 fa-copy"></span>
						<span>{lang}shop.product.share.bbcode{/lang}</span>
					</a>
				</li>
				{if $product->getScreenshotList()|count}
					<li>
						<a href="{link application='shop' controller='ProductScreenshot' object=$product}{/link}" class="button">
							<span class="icon icon16 fa-eye"></span>
							<span>{lang}shop.product.button.screenshots{/lang}</span>
						</a>
					</li>
				{/if}

				{if SHOP_MODULE_PRODUCTS_REVIEW && $product->canViewReview()}
					<li>
						<a href="{link application='shop' controller='ProductReview' object=$product}{/link}" class="button">
							<span class="icon icon16 fa-star"></span>
							<span>{lang}shop.product.button.review{/lang}</span>
						</a>
					</li>
				{/if}

				{if $product->canRecommend && $__wcf->session->getPermission('user.shop.products.canRecommend')}
					<li>
						<a class="button customerProductRecommend" data-product-id="{@$product->productID}">
							<span class="icon icon16 fa-share-alt"></span>
							<span>{lang}shop.product.recommend{/lang}</span>
						</a>
					</li>
				{/if}

				{event name='contentNavigationButtonsBottom'}
			</ul>
		</nav>
	</div>

	{if ENABLE_SHARE_BUTTONS}
		<section class="section jsOnly">
			<h2 class="sectionTitle">{lang}wcf.message.share{/lang}</h2>

			{include file='shareButtons'}
		</section>
	{/if}
</div>

<script data-relocate="true">
    require(['VieCode/Shop/Ui/Product/Recommend', 'VieCode/Shop/Ui/Product/BBCode', 'Language'], function (ProductRecommend, ProductBBCode, Language) {
        Language.addObject({
            'wcf.message.share': '{lang}wcf.message.share{/lang}',
            'wcf.message.share.facebook': '{lang}wcf.message.share.facebook{/lang}',
            'wcf.message.share.google': '{lang}wcf.message.share.google{/lang}',
            'wcf.message.share.permalink': '{lang}wcf.message.share.permalink{/lang}',
            'wcf.message.share.permalink.bbcode': '{lang}wcf.message.share.permalink.bbcode{/lang}',
            'wcf.message.share.permalink.html': '{lang}wcf.message.share.permalink.html{/lang}',
            'wcf.message.share.reddit': '{lang}wcf.message.share.reddit{/lang}',
            'wcf.message.share.twitter': '{lang}wcf.message.share.twitter{/lang}',
            'shop.product.recommend': '{lang}shop.product.recommend{/lang}'
        });
        ProductRecommend.init();
        ProductBBCode.init();
    });
    $(function () {
        new WCF.Message.Share.Content();
    });
</script>

{include file='footer'}
