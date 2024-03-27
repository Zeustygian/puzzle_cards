package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.Shape;

class PlayState extends FlxState
{
	var array_card = new Array<FlxSprite>();

	override public function create()
	{
		super.create();

		var map = [1 => 100, 2 => 150, 3 => 200];
		for (i in 0...3) {
			if (i == 0) {
				for (key => value in map) {
					var blueGraphic:FlxSprite = new FlxSprite(100, value);
					blueGraphic.makeGraphic(30, 30, FlxColor.BLUE);
					array_card.push(blueGraphic);
					add(blueGraphic);
				}
			}
			if (i == 1) {
				for (key => value in map) {
					var blueGraphic:FlxSprite = new FlxSprite(150, value);
					blueGraphic.makeGraphic(30, 30, FlxColor.RED);
					array_card.push(blueGraphic);
					add(blueGraphic);
				}
			}
			if (i == 2) {
				for (key => value in map) {
					var blueGraphic:FlxSprite = new FlxSprite(200, value);
					blueGraphic.makeGraphic(30, 30, FlxColor.GREEN);
					array_card.push(blueGraphic);
					add(blueGraphic);
				}
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		for (card in array_card) {
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(card)) {
				var new_color = new FlxSprite(card.x, card.y);
				new_color.makeGraphic(30, 30, FlxColor.GREEN);
				var index:Int = array_card.indexOf(card);
				array_card[index] = new_color;
				add(array_card[index]);
			}
		}
	}
}
