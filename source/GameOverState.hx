package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.display.SpreadMethod;
import openfl.display.Sprite;

class GameOverState extends FlxState
{
	var background:FlxSprite;
	var game_over:FlxSprite;
	var score:FlxText;
	var totalScore:Int;

	public function new(totalScore:Int)
	{
		super();
		this.totalScore = totalScore;
	}

	override public function create()
	{
		super.create();

		background = new FlxSprite();
		background.loadGraphic(AssetPaths.menu_background__png);
		background.scale.set(FlxG.width / background.width, FlxG.height / background.height);
		background.updateHitbox();
		add(background);

		game_over = new FlxSprite(15, 60);
		game_over.loadGraphic(AssetPaths.game_over__png);
		add(game_over);

		score = new FlxText(0, 250, FlxG.width, "You peaked at:\n" + totalScore, 16);
		score.setFormat(null, 40, FlxColor.WHITE, FlxTextAlign.CENTER);
		score.updateHitbox();
		add(score);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
		{
			FlxG.camera.fade(FlxColor.BLACK, 0.33, false, function()
			{
				FlxG.switchState(new MenuState());
			});
		}
	}
}
