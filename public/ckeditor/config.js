/*
Copyright (c) 2003-2010, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/


CKEDITOR.editorConfig = function( config )
{
  config.toolbar = 'MyToolbar';

  config.toolbar_MyToolbar =
  [
      ['Bold','Italic','Strike'], ['Image'],
      ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
      ['Link','Unlink'],
      ['Maximize']
  ];

  config.uiColor = '#9AB8F3';
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
};
