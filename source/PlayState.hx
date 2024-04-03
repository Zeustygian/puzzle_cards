package;

import flixel.animation.FlxBaseAnimation;
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
	var array_card_solution = new Array<Array<Card>>();
	var solution_flip_state = new Array<Bool>();
	var array_card = new Array<Array<Card>>();
	var player_flip_state = new Array<Bool>();

	var random = new flixel.math.FlxRandom();

	override public function create()
	{
		super.create();

		generate_puzzle_solution();
		generate_puzzle_player();
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
		check_resolved_puzzle();
	}

	public function click_card(array_card:Array<Array<Card>>, line:Array<Card>, card:Card, index:Int, line_cursor:Int):Void
	{
		if (line[index].flipped == true)
			line[index].flipped = false;
		else
			line[index].flipped = true;
		switch_around_cards(array_card, line, card, index, line_cursor);
		update_flip_state();
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

	public function update_flip_state() {
		player_flip_state = [];

		for (line in array_card) {
			for (card in line) {
				if (card.flipped == true)
					player_flip_state.push(true);
				else
					player_flip_state.push(false);
			}
		}
		trace(player_flip_state);
		trace("###########");
	}

	public function set_solution_flip_state() {
		solution_flip_state = [];

		for (line in array_card_solution) {
			for (card in line) {
				if (card.flipped == true)
					solution_flip_state.push(true);
				else
					solution_flip_state.push(false);
			}
		}
	}

	public function generate_puzzle_solution() {
		var pos_x = [70, 134, 198];
		var pos_y = [30, 94, 158];

		for (y in pos_y) {
			var array_line:Array<Card> = [];
			for (x in pos_x) {
				var card:Card = new Card(x, y);
				card.updateHitbox();
				array_line.push(card);
				add(card);
			}
			array_card_solution.push(array_line);
		}

		for (i in 0...random.int(2, 6)) {
			var rand_row = random.int(0, array_card_solution.length - 1);
			var rand_index = random.int(0, array_card_solution[rand_row].length - 1);

			// trace(rand_row);
			// trace(rand_index);
			// trace("========");

			if (array_card_solution[rand_row][rand_index].flipped == true)
				array_card_solution[rand_row][rand_index].flipped = false;
			else
				array_card_solution[rand_row][rand_index].flipped = true;
			switch_around_cards(array_card_solution, array_card_solution[rand_row], array_card_solution[rand_row][rand_index], 
				rand_index, rand_row);
		}
		set_solution_flip_state();
		trace(solution_flip_state);
		trace("-------------");
	}

	public function generate_puzzle_player() {
		var pos_x = [70, 134, 198];
		var pos_y = [250, 314, 378];

		for (y in pos_y) {
			var array_line:Array<Card> = [];
			for (x in pos_x) {
				var card:Card = new Card(x, y);
				card.updateHitbox();
				array_line.push(card);
				add(card);
			}
			array_card.push(array_line);
		}
		update_flip_state();
		trace(player_flip_state);
		trace("-------------");
	}

	public function check_resolved_puzzle() {
		var matching_card_state = 0;

		for (i in 0...solution_flip_state.length) {
			if (player_flip_state[i] != solution_flip_state[i])
				break;
			else
				matching_card_state++;
		}
		// if (matching_card_state == solution_flip_state.length) {
		// 	// trace("SOLVED !");
		// 	FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
		// 	{
		// 		FlxG.switchState(new MenuState());
		// 	});
		// }
	}
}