package objects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Exit extends FlxSprite {

    public function new(X : Float = 0, Y : Float = 0, ? SimpleGraphic : FlxGraphicAsset) {
        super(X, Y);
        loadGraphic(Data.ExitImg, false, 32, 32);
    }

}