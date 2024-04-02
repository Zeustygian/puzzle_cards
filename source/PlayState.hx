package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Card extends FlxSprite {
	public var flipped:Bool = false;
	public var previous_flip:Bool = false;

	public function new(?x:Float = 0, ?y:Float = 0, ?asset:String = "assets/images/cat.png") {
		super(x, y);
		loadGraphic(asset);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (flipped == true && previous_flip == false) {
			previous_flip = true;
			this.loadGraphic("assets/images/pog.png");
		}
		if (flipped == false && previous_flip == true) {
			previous_flip = false;
			this.loadGraphic("assets/images/cat.png");
		}
	}
}

class PlayState extends FlxState
{
	var array_card = new Array<Array<Card>>();

	override public function create()
	{
		super.create();
		var pos = [50, 120, 190];

		for (i in 0...3) {
			var array_line:Array<Card> = [];
			for (a in 0 ... 3) {
				var card:Card = new Card(pos[a], pos[i]);
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
		var line_cursor:Int = 0;
		
		for (line in array_card) {
			var index:Int = 0;
			for (card in line) {
				if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(card)) {
					click_card(array_card, line, card, index, line_cursor);
				}
				index++;
			}
			line_cursor++;
		}
	}

	public function click_card(array_card:Array<Array<Card>>, line:Array<Card>, card:Card, index:Int, line_cursor:Int):Void
	{

		if (line[index].flipped == true)
			line[index].flipped = false;
		else
			line[index].flipped = true;

		switch_around_cards(array_card, line, card, index, line_cursor);
	}

	public function switch_around_cards(array_card:Array<Array<Card>>, line:Array<Card>, card:Card, index:Int, line_cursor:Int) {
		if (Std.isOfType(line[index + 1], Card)) {
			if (line[index + 1].flipped == true)
				line[index + 1].flipped = false;
			else
				line[index + 1].flipped = true;
		}
		if (Std.isOfType(line[index - 1], Card)) {
			if (line[index - 1].flipped == true)
				line[index - 1].flipped = false;
			else
				line[index - 1].flipped = true;
		}

		if (line_cursor > 0) {
			if (Std.isOfType(array_card[line_cursor - 1][index], Card)) {
				if (array_card[line_cursor - 1][index].flipped == true)
					array_card[line_cursor - 1][index].flipped = false;
				else
					array_card[line_cursor - 1][index].flipped = true;
			}
		}
		if (line_cursor < array_card.length - 1) {
			if (Std.isOfType(array_card[line_cursor + 1][index], Card)) {
				if (array_card[line_cursor + 1][index].flipped == true)
					array_card[line_cursor + 1][index].flipped = false;
				else
					array_card[line_cursor + 1][index].flipped = true;
			}
		}
	}
}
