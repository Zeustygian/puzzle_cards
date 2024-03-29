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
	var array_card = new Array<Array<FlxSprite>>();

	override public function create()
	{
		super.create();
		var map = [1 => 50, 2 => 120, 3 => 190];
		var y_pos = [50, 120, 190];

		for (i in 0...3) {
			var array_line:Array<FlxSprite> = [];
			for (key => value in map) {
				var card:FlxSprite = new FlxSprite(value, y_pos[i], "assets/images/cat.png");
				card.updateHitbox();
				array_line.push(card);
				add(card);
			}
			array_card.push(array_line);
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		for (line in array_card) {
			for (card in line) {
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(card)) {
					var new_color:FlxSprite = new FlxSprite(card.x, card.y, "assets/images/pog.png");
					new_color.updateHitbox();
					var index:Int = line.indexOf(card);
					remove(line[index]);
					line[index] = new_color;
					add(line[index]);
				}
			}
		}
	}
}
