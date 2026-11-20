package arilovecherry.stages;

import funkin.play.stage.Stage;
import funkin.play.stage.Bopper;

class ExampleStage extends Stage
{
  var myBopper:Bopper;

  public function new()
  {
    super('exampleStage');
  }

  override function onCreate(event:ScriptEvent):Void
  {
    super.onCreate(event);

    // dance every
    myBopper = new Bopper(1);

    myBopper.loadSparrow('gameplay/stages/myStage/myBopper');

    // anims
    myBopper.animation.addByPrefix('idle', 'idle', 24, false);
    myBopper.animation.addByPrefix('miss', 'miss', 24, false);

    // offsets
    myBopper.setAnimationOffsets('idle', 0, 0);
    myBopper.setAnimationOffsets('miss', 10, -5);

    // stage position and scroll factor
    myBopper.x = 400;
    myBopper.y = 300;
    myBopper.zIndex = 100;
    myBopper.scrollFactor.set(1, 1);

    // need
    myBopper.originalPosition.set(myBopper.x, myBopper.y);

    // add to stage, see Stage.hx
    addBopper(myBopper, 'myBopper');

    // play idle animation and refresh the stage to apply changes
    myBopper.playAnimation('idle', true);
    refresh();
  }

  // alternative way to handle note misses, without needing to create a custom character class
  override function onNoteMiss(event:NoteScriptEvent):Void
  {
    super.onNoteMiss(event);

    if (event.eventCanceled) return;

    // only react to player misses
    if (!event.note.noteData.getMustHitNote()) return;

    // restart the animation on every miss, [anim, force, ignoreOther]
    myBopper.playAnimation('miss', true, true);
  }
}