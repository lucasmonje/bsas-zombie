package  
{
	/**
	 * ...
	 * @author Lucas Monje
	 */
	public class EmbedAsset {
		
		[Embed(source='..\\bin\\resources\\assets-config.xml',mimeType="application/octet-stream")]
		public static var xmlAssetsConfigClass:Class;
		
		[Embed(source='..\\bin\\resources\\worlds-config.xml',mimeType="application/octet-stream")]
		public static var xmlWorldsConfigClass:Class;
		
		[Embed(source='..\\bin\\resources\\items-config.xml',mimeType="application/octet-stream")]
		public static var xmlItemsConfigClass:Class;
		
		[Embed(source='..\\bin\\resources\\sounds-config.xml',mimeType="application/octet-stream")]
		public static var xmlSoundsConfigClass:Class;
		
		[Embed(source='..\\bin\\resources\\preloader-config.xml',mimeType="application/octet-stream")]
		public static var xmlGameConfigClass:Class;
				
		[Embed(source='..\\bin\\resources\\popups-config.xml',mimeType="application/octet-stream")]
		public static var popupsConfigClass:Class;
		
	}

}