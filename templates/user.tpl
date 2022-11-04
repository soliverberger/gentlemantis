{capture assign='pageTitle'}{$user->username} - {lang}wcf.user.members{/lang}{/capture}

{capture assign='headContent'}
	{event name='javascriptInclude'}
	<script data-relocate="true">
		{if $__wcf->getUser()->userID && $__wcf->getUser()->userID != $user->userID}
			require(['Language', 'WoltLabSuite/Core/Ui/User/Editor', 'WoltLabSuite/Core/Ui/User/Profile/Menu/Item/Ignore', 'WoltLabSuite/Core/Ui/User/Profile/Menu/Item/Follow'], function(Language, UiUserEditor, UiUserProfileMenuItemIgnore, UiUserProfileMenuItemFollow) {
				Language.addObject({
					'wcf.acp.user.disable': '{jslang}wcf.acp.user.disable{/jslang}',
					'wcf.acp.user.enable': '{jslang}wcf.acp.user.enable{/jslang}',
					'wcf.user.ban': '{jslang}wcf.user.ban{/jslang}',
					'wcf.user.banned': '{jslang}wcf.user.banned{/jslang}',
					'wcf.user.ban.confirmMessage': '{jslang}wcf.user.ban.confirmMessage{/jslang}',
					'wcf.user.ban.expires': '{jslang}wcf.user.ban.expires{/jslang}',
					'wcf.user.ban.expires.description': '{jslang}wcf.user.ban.expires.description{/jslang}',
					'wcf.user.ban.neverExpires': '{jslang}wcf.user.ban.neverExpires{/jslang}',
					'wcf.user.ban.reason.description': '{jslang}wcf.user.ban.reason.description{/jslang}',
					'wcf.user.button.follow': '{jslang}wcf.user.button.follow{/jslang}',
					'wcf.user.button.unfollow': '{jslang}wcf.user.button.unfollow{/jslang}',
					'wcf.user.button.ignore': '{jslang}wcf.user.button.ignore{/jslang}',
					'wcf.user.button.unignore': '{jslang}wcf.user.button.unignore{/jslang}',
					'wcf.user.disableAvatar': '{jslang}wcf.user.disableAvatar{/jslang}',
					'wcf.user.disableAvatar.confirmMessage': '{jslang}wcf.user.disableAvatar.confirmMessage{/jslang}',
					'wcf.user.disableAvatar.expires': '{jslang}wcf.user.disableAvatar.expires{/jslang}',
					'wcf.user.disableAvatar.expires.description': '{jslang}wcf.user.disableAvatar.expires.description{/jslang}',
					'wcf.user.disableAvatar.neverExpires': '{jslang}wcf.user.disableAvatar.neverExpires{/jslang}',
					'wcf.user.disableCoverPhoto': '{jslang}wcf.user.disableCoverPhoto{/jslang}',
					'wcf.user.disableCoverPhoto.confirmMessage': '{jslang}wcf.user.disableCoverPhoto.confirmMessage{/jslang}',
					'wcf.user.disableCoverPhoto.expires': '{jslang}wcf.user.disableCoverPhoto.expires{/jslang}',
					'wcf.user.disableCoverPhoto.expires.description': '{jslang}wcf.user.disableCoverPhoto.expires.description{/jslang}',
					'wcf.user.disableCoverPhoto.neverExpires': '{jslang}wcf.user.disableCoverPhoto.neverExpires{/jslang}',
					'wcf.user.disableSignature': '{jslang}wcf.user.disableSignature{/jslang}',
					'wcf.user.disableSignature.confirmMessage': '{jslang}wcf.user.disableSignature.confirmMessage{/jslang}',
					'wcf.user.disableSignature.expires': '{jslang}wcf.user.disableSignature.expires{/jslang}',
					'wcf.user.disableSignature.expires.description': '{jslang}wcf.user.disableSignature.expires.description{/jslang}',
					'wcf.user.disableSignature.neverExpires': '{jslang}wcf.user.disableSignature.neverExpires{/jslang}',
					'wcf.user.edit': '{jslang}wcf.user.edit{/jslang}',
					'wcf.user.enableAvatar': '{jslang}wcf.user.enableAvatar{/jslang}',
					'wcf.user.enableCoverPhoto': '{jslang}wcf.user.enableCoverPhoto{/jslang}',
					'wcf.user.enableSignature': '{jslang}wcf.user.enableSignature{/jslang}',
					'wcf.user.unban': '{jslang}wcf.user.unban{/jslang}'
				});
				
				{if $isAccessible}
					UiUserEditor.init();
				{/if}
				
				{if !$user->getPermission('user.profile.cannotBeIgnored')}
					new UiUserProfileMenuItemIgnore({@$user->userID}, {if $__wcf->getUserProfileHandler()->isIgnoredUser($user->userID)}true{else}false{/if});
				{/if}
				
				{if !$user->isIgnoredUser($__wcf->user->userID)}
					new UiUserProfileMenuItemFollow({@$user->userID}, {if $__wcf->getUserProfileHandler()->isFollowing($user->userID)}true{else}false{/if});
				{/if}
			});
		{/if}
		
		$(function() {
			{if $__wcf->getUser()->userID && $__wcf->getUser()->userID != $user->userID}
				WCF.Language.addObject({
					'wcf.user.activityPoint': '{jslang}wcf.user.activityPoint{/jslang}'
				});
			{/if}
			
			new WCF.User.Profile.TabMenu({@$user->userID});
			
			{if $user->canEdit() || ($__wcf->getUser()->userID == $user->userID && $user->canEditOwnProfile())}
				WCF.Language.addObject({
					'wcf.user.editProfile': '{jslang}wcf.user.editProfile{/jslang}'
				});
				
				var userProfileEditor = new WCF.User.Profile.Editor({@$user->userID}, {if $editOnInit}true{else}false{/if});
				{if $__wcf->getUser()->userID == $user->userID}
					var editLink = elBySel('.interactiveDropdownItemsUserMenu .jsUserPanelEditProfile');
					if (editLink) {
						editLink.addEventListener(WCF_CLICK_EVENT, function (event) {
							userProfileEditor._beginEdit(event);
							
							WCF.CloseOverlayHandler.forceExecution();
						});
					}
				{/if}
			{/if}
			
			{if $followingCount > 7}
				var $followingList = null;
				$('#followingAll').click(function() {
					if ($followingList === null) {
						$followingList = new WCF.User.List('wcf\\data\\user\\follow\\UserFollowingAction', $('#followingAll').parents('section').children('.boxTitle').text().replace(/ \d+$/, ''), { userID: {@$user->userID} });
					}
					
					$followingList.open();
				});
			{/if}
			{if $followerCount > 7}
				var $followerList = null;
				$('#followerAll').click(function() {
					if ($followerList === null) {
						$followerList = new WCF.User.List('wcf\\data\\user\\follow\\UserFollowAction', $('#followerAll').parents('section').children('.boxTitle').text().replace(/ \d+$/, ''), { userID: {@$user->userID} });
					}
					
					$followerList.open();
				});
			{/if}
			{if $visitorCount > 7}
				var $visitorList = null;
				$('#visitorAll').click(function() {
					if ($visitorList === null) {
						$visitorList = new WCF.User.List('wcf\\data\\user\\profile\\visitor\\UserProfileVisitorAction', $('#visitorAll').parents('section').children('.boxTitle').text().replace(/ \d+$/, ''), { userID: {@$user->userID} });
					}
					
					$visitorList.open();
				});
			{/if}
			
			{if $__wcf->session->getPermission('user.profile.canReportContent')}
				WCF.Language.addObject({
					'wcf.moderation.report.reportContent': '{jslang}wcf.user.profile.report{/jslang}',
					'wcf.moderation.report.success': '{jslang}wcf.moderation.report.success{/jslang}'
				});
				new WCF.Moderation.Report.Content('com.woltlab.wcf.user', '.jsReportUser');
			{/if}
			
			{event name='javascriptInit'}
		});
	</script>
	
	<noscript>
		<style type="text/css">
			#profileContent > .tabMenu > ul > li:not(:first-child) {
				display: none !important;
			}
			
			#profileContent > .tabMenuContent:not(:first-of-type) {
				display: none !important;
			}
		</style>
	</noscript>
{/capture}


{include file='userSidebar' assign='sidebarRight'}

{include file='header'}

{if !$user->isProtected()}
	<div id="profileContent" class="section tabMenuContainer userProfileContent" data-active="{$__wcf->getUserProfileMenu()->getActiveMenuItem($userID)->getIdentifier()}">
		<nav class="tabMenu">
			<ul>
				{foreach from=$__wcf->getUserProfileMenu()->getMenuItems() item=menuItem}
					{if $menuItem->getContentManager()->isVisible($userID)}
						<li><a href="{@$__wcf->getAnchor($menuItem->getIdentifier())}">{$menuItem}</a></li>
					{/if}
				{/foreach}
			</ul>
		</nav>
		
		{foreach from=$__wcf->getUserProfileMenu()->getMenuItems() item=menuItem}
			{if $menuItem->getContentManager()->isVisible($userID)}
				<div id="{$menuItem->getIdentifier()}" class="tabMenuContent" data-menu-item="{$menuItem->menuItem}">
					{if $menuItem === $__wcf->getUserProfileMenu()->getActiveMenuItem($userID)}
						{@$profileContent}
					{/if}
				</div>
			{/if}
		{/foreach}
	</div>
{else}
	<p class="info" role="status">{lang}wcf.user.profile.protected{/lang}</p>
{/if}

{if MODULE_USER_COVER_PHOTO && ($user->userID == $__wcf->user->userID || $user->canEdit())}
	{if $__wcf->getSession()->getPermission('user.profile.coverPhoto.canUploadCoverPhoto')}
		<div id="userProfileCoverPhotoUpload" class="jsStaticDialogContent" data-title="{lang}wcf.user.coverPhoto.upload{/lang}">
			{if $__wcf->user->disableCoverPhoto}
				<p class="error" role="alert">{lang}wcf.user.coverPhoto.error.disabled{/lang}</p>
			{else}
				<div id="coverPhotoUploadPreview"></div>
				
				{* placeholder for the upload button *}
				<div id="coverPhotoUploadButtonContainer"></div>
				<small>{lang}wcf.user.coverPhoto.upload.description{/lang}</small>
			{/if}
		</div>
		<script data-relocate="true">
			require(['Language', 'WoltLabSuite/Core/Ui/User/CoverPhoto/Upload'], function (Language, UiUserCoverPhotoUpload) {
				Language.addObject({
					'wcf.user.coverPhoto.delete.confirmMessage': '{jslang}wcf.user.coverPhoto.delete.confirmMessage{/jslang}',
					'wcf.user.coverPhoto.upload.error.fileExtension': '{jslang}wcf.user.coverPhoto.upload.error.fileExtension{/jslang}',
					'wcf.user.coverPhoto.upload.error.tooLarge': '{jslang}wcf.user.coverPhoto.upload.error.tooLarge{/jslang}',
					'wcf.user.coverPhoto.upload.error.uploadFailed': '{jslang}wcf.user.coverPhoto.upload.error.uploadFailed{/jslang}',
					'wcf.user.coverPhoto.upload.error.badImage': '{jslang}wcf.user.coverPhoto.upload.error.badImage{/jslang}'
				});
				
				{if !$__wcf->user->disableCoverPhoto}
					new UiUserCoverPhotoUpload({@$user->userID});
				{/if}
			});
		</script>
	{/if}
	<script data-relocate="true">
		require(['Language', 'WoltLabSuite/Core/Ui/User/CoverPhoto/Delete'], function (Language, UiUserCoverPhotoDelete) {
			Language.addObject({
				'wcf.user.coverPhoto.delete.confirmMessage': '{jslang}wcf.user.coverPhoto.delete.confirmMessage{/jslang}'
			});
			
			UiUserCoverPhotoDelete.init({@$user->userID});
		});
	</script>
{/if}

{include file='footer'}
