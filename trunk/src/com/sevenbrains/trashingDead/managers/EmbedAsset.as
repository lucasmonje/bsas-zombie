package com.sevenbrains.trashingDead.managers 
{
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class EmbedAsset {
		
		[Embed(source='..\\..\\..\\..\\..\\resources\\assets-config.xml',mimeType="application/octet-stream")]
		public static var xmlAssetsConfigClass:Class;
		
		[Embed(source='..\\..\\..\\..\\..\\resources\\worlds-config.xml',mimeType="application/octet-stream")]
		public static var xmlWorldsConfigClass:Class;
		
		[Embed(source='..\\..\\..\\..\\..\\resources\\items-config.xml',mimeType="application/octet-stream")]
		public static var xmlItemsConfigClass:Class;
		
		[Embed(source='..\\..\\..\\..\\..\\resources\\sounds-config.xml',mimeType="application/octet-stream")]
		public static var xmlSoundsConfigClass:Class;
		
		[Embed(source='..\\..\\..\\..\\..\\resources\\game-config.xml',mimeType="application/octet-stream")]
		public static var xmlGameConfigClass:Class;
		
	}

}