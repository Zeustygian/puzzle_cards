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
		background.loadGraphic(AssetPaths.background__png);
		background.updateHitbox();
		add(background);

		score = new FlxText(0, 30, FlxG.width, "Your score is:\n\n" + totalScore, 16);
		score.setFormat(null, 40, FlxColor.WHITE, FlxTextAlign.CENTER);
		score.color = FlxColor.YELLOW;
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
