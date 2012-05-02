package com.sevenbrains.trashingDead.display.popup
{
    import com.sevenbrains.trashingDead.utils.Enum;
    
    public class PopupChannel extends Enum
    {
        public static const CONFIRMATION:PopupChannel = new PopupChannel();
        public static const DEFAULT:PopupChannel = new PopupChannel();
        public static const BUY:PopupChannel = new PopupChannel();
        public static const ERROR:PopupChannel = new PopupChannel();
        public static const NOTIFICATION:PopupChannel = new PopupChannel();
        
        private static const ALL:Vector.<PopupChannel> = Vector.<PopupChannel>(
            [DEFAULT, BUY, CONFIRMATION, NOTIFICATION]
        );
        
        // static block
        {
            initEnumConstant(PopupChannel);
        }
        
        public static function getAll():Vector.<PopupChannel> {
            return ALL;
        }
    }
}