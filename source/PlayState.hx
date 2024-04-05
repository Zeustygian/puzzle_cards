package;

import flixel.addons.effects.chainable.FlxShakeEffect;
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
		// this.scale.x = 0.85;
		// this.scale.y = 0.85;
		// this.updateHitbox();
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
	var hide_button = new FlxSprite();
	var soluce_view:Bool = true;
	var current_view_txt = new FlxText();
	var random = new flixel.math.FlxRandom();
	var background = new FlxSprite();

	override public function create()
	{
		super.create();

		background.loadGraphic("assets/images/background_one.png");
		add(background);

		generate_puzzle_solution();
		create_hide_soluce_button();
		generate_puzzle_player();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		var line_cursor:Int = 0;
		
		if (soluce_view == false) {
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
		switch_views();
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

	public function create_hide_soluce_button() {
		hide_button.makeGraphic(128, 64, FlxColor.RED);
		hide_button.x = 200;
		hide_button.y = 380;
		add(hide_button);

		var switch_button_text = new FlxText();
		switch_button_text.text = "Switch";
		switch_button_text.size = 24;
		switch_button_text.x = hide_button.x + 10;
		switch_button_text.y = hide_button.y + 10;
		add(switch_button_text);

		current_view_txt.text = "GOAL";
		current_view_txt.size = 32;
		current_view_txt.color = FlxColor.YELLOW;
		current_view_txt.x = 100;
		current_view_txt.y = 30;
		add(current_view_txt);
	}

	public function generate_puzzle_solution() {
		var spacing = 64;
		var pos_x = [30];
		var pos_y = [110];

		for (i in 0...3)
			pos_x.push(pos_x[pos_x.length - 1] + 64);
		for (i in 0...3)
			pos_y.push(pos_y[pos_y.length - 1] + 64);

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

		// choose random card to reverse
		for (i in 0...random.int(2, 6)) {
			var rand_row = random.int(0, array_card_solution.length - 1);
			var rand_index = random.int(0, array_card_solution[rand_row].length - 1);

			trace(rand_row);
			trace(rand_index);
			trace("========");

			if (array_card_solution[rand_row][rand_index].flipped == true)
				array_card_solution[rand_row][rand_index].flipped = false;
			else
				array_card_solution[rand_row][rand_index].flipped = true;
			switch_around_cards(array_card_solution, array_card_solution[rand_row], array_card_solution[rand_row][rand_index], 
				rand_index, rand_row);
		}
		set_solution_flip_state();
	}

	public function generate_puzzle_player() {
		var spacing = 64;
		var pos_x = [30];
		var pos_y = [110];

		for (i in 0...3)
			pos_x.push(pos_x[pos_x.length - 1] + 64);
		for (i in 0...3)
			pos_y.push(pos_y[pos_y.length - 1] + 64);


		for (y in pos_y) {
			var array_line:Array<Card> = [];
			for (x in pos_x) {
				var card:Card = new Card(x, y);
				card.updateHitbox();
				card.visible = false;
				array_line.push(card);
				add(card);
			}
			array_card.push(array_line);
		}
		update_flip_state();
	}

	public function switch_views() {
		if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(hide_button)) {
			if (soluce_view == true) {
				soluce_view = false;
				current_view_txt.text = "YOU";
				for (line in array_card_solution) {
					for (solution_card in line) {
						solution_card.visible = false;
					}
				}
				for (line in array_card) {
					for (player_card in line) {
						player_card.visible = true;
					}
				}
			} else {
				soluce_view = true;
				current_view_txt.text = "GOAL";
				for (line in array_card_solution) {
					for (solution_card in line) {
						solution_card.visible = true;
					}
				}
				for (line in array_card) {
					for (player_card in line) {
						player_card.visible = false;
					}
				}
			}
		}
	}

	public function check_resolved_puzzle() {
		var matching_card_state = 0;

		for (i in 0...solution_flip_state.length) {
			if (player_flip_state[i] != solution_flip_state[i])
				break;
			else
				matching_card_state++;
		}
		if (matching_card_state == solution_flip_state.length) {
			// trace("SOLVED !");
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				FlxG.switchState(new MenuState());
			});
		}
	}
}