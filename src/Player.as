package
{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source="../assets/new/girl.png")] private var ImgPlayer:Class;
        public var stuffing:Number = -1;
        public var holding:Boolean = false;
        public var held:Boolean = false;
        public var play_done:Boolean = false;
        public var frame_counter:Number = 0;

        public function Player(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgPlayer, true, false, 322, 344, true);
            addAnimation("idle",[],0,false);
            addAnimation("0",[1],0,false);
            addAnimation("1",[2],0,false);
            addAnimation("2",[3],0,false);
            addAnimation("3",[4],0,false);
            addAnimation("done",[5,6,7],1,true);
            play("0");
        }

        public function playAnim(s:String):void {
            this.play(s);
        }

        public function curFrame():Number {
            return this._curFrame;
        }

        override public function update():void{
            super.update();
            if(!holding) {
                this.play("idle");
            } else if(this.stuffing <= 0) {
                this.play("0");
            } else if(this.stuffing == 1) {
                this.play("1");
            } else if(this.stuffing == 2) {
                this.play("2");
            } else if(this.stuffing == 3) {
                this.play("3");
            } else if(this.stuffing == 4) {
                if(!this.play_done) {
                    this.play("done");
                    this.play_done = true;
                }
                if(this._curFrame == 2) {
                    if(this.frame_counter <= 50) {
                        this.frame_counter++;
                    } else {
                        this.stuffing = -1;
                        this.held = true;
                        this.holding = false;
                        this.play_done = false;
                        this.frame_counter = 0;
                    }
                }
            }
        }
    }
}