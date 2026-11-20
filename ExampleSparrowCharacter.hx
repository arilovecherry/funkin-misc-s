package arilovecherry.characters;

import funkin.play.character.SparrowCharacter;
import funkin.play.GameOverSubState;
import funkin.play.PlayState;

class ExampleCharacter extends SparrowCharacter
{
  public function new()
  {
    super('ari');
  }

  override function onNoteMiss(event:NoteScriptEvent):Void
  {
    super.onNoteMiss(event);
    if (event.eventCanceled) return;

    // only react to player misses and if the character is BF, BF is inherited from BaseCharacter, see BaseCharacter.hx
    if (!(event.note.noteData.getMustHitNote() && characterType == BF)) return;

    var stage = currentStage ?? PlayState.instance?.currentStage;
    if (stage == null) return;

    var bopper = stage.getNamedProp('myBopper');
    if (bopper == null) return;

    // play animation
    bopper.playAnimation('miss', true, true);
  }

  //stolen picoplayable code
  override function onNoteHit(event:HitNoteScriptEvent):Void
  {
    if (event.eventCanceled)
    {
      // onNoteHit event was cancelled by the gameplay module
      return;
    }

    // Override the hit note animation
    switch (event.note.kind)
    {
      case 'hey':
        holdTimer = 0;
        this.playAnimation('hey', true, true);
        return;
      case 'cheer':
        holdTimer = 0;
        this.playAnimation('cheer', true, true);
        return;
      case 'censor':
        holdTimer = 0;
        this.playSingAnimation(event.note.noteData.getDirection(), false, 'censor');
        return;
      default:
        super.onNoteHit(event);
    }
  }
}