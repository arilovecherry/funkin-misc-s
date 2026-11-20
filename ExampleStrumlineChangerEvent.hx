package arilovecherry.modules;

import funkin.modding.module.Module;
import funkin.play.PlayState;
import funkin.play.notes.Strumline;
import funkin.data.notestyle.NoteStyleRegistry;

class ReplaceStrumlineModule extends Module {
	var TRIGGER_STEP:Int = 88;
	var STYLE_ID:String = "funkin";
	var REPLACE_PLAYER:Bool = false;

    // inmutable
	var hasReplaced:Bool = false;

	public function new() {
		super("ReplaceStrumlineModule");
	}

	override function onSongRetry(event) {
		hasReplaced = false;
	}

	override function onStepHit(event) {
		if (hasReplaced || event.step != TRIGGER_STEP) return;

		hasReplaced = true;
		replaceStrumline(STYLE_ID, REPLACE_PLAYER);
	}

	/**
	 * Swaps a strumline for a freshly built one that uses the given note style
	 *
	 * @param styleId ID of the note style registered in NoteStyleRegistry
	 * @param isPlayer true = player strumline, false = opponent strumline
	 */
	public function replaceStrumline(styleId:String, isPlayer:Bool) {
		var game = PlayState.instance;
		if (game == null) return;

		var oldStrumline = isPlayer ? game.playerStrumline : game.opponentStrumline;
		var noteData = oldStrumline.noteData;
		var oldPosition = [oldStrumline.x, oldStrumline.y];
		var daStyle = NoteStyleRegistry.instance.fetchEntry(styleId);

		game.remove(oldStrumline);
		oldStrumline.kill();

		var newStrumline = new Strumline(daStyle, isPlayer);
		newStrumline.onNoteIncoming.add(game.onStrumlineNoteIncoming);
		newStrumline.applyNoteData(noteData);
		game.add(newStrumline);

		newStrumline.camera = game.camHUD;
		newStrumline.setPosition(oldPosition[0], oldPosition[1]);
		newStrumline.fadeInArrows();

		// PlayState keeps separate references, so the new strumline must be assigned back
		if (isPlayer) game.playerStrumline = newStrumline;
		else game.opponentStrumline = newStrumline;
	}
}
