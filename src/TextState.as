package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="../assets/glass.mp3")] private var GlassSound:Class;
        [Embed(source="../assets/new/brokenbulb.png")] private var BgImg:Class;
        [Embed(source="../assets/new/auxpuces.mp3")] private var ClockSound:Class;
        [Embed(source="../assets/new/leave.mp3")] private var LeaveSound:Class;
        [Embed(source="../assets/new/TITLE_A.png")] private var ImgBg1:Class;
        [Embed(source="../assets/new/TITLE_B.png")] private var ImgBg2:Class;
        [Embed(source="../assets/new/TITLE_B_BUBBLE.png")] private var ImgBubble:Class;

        public var nextState:FlxState;
        public var ending:String;
        public var end_text:FlxText;
        public var bg1:FlxSprite;
        public var bg2:FlxSprite;
        public var bubble:FlxSprite;
        public var end_string:String;
        public var opening_text:FlxText;

        public function TextState(e_text:String, end:String) {
            super();
            end_string = e_text;
            //this.nextState = next;
            ending = end;
            FlxG.bgColor = 0xff000000;
        }

        override public function create():void
        {
            endTime = 4;
            end_text = new FlxText(0,FlxG.height/2-10,FlxG.width,end_string);
            end_text.setFormat("zaguatica-Bold",24,0xffffffff,"center");

            if(ending == "end 1"){
                FlxG.music.stop();
                FlxG.play(GlassSound);
            } else if(ending == "end 2") {
                var bg:FlxSprite = new FlxSprite(0,0);
                bg.loadGraphic(BgImg,false,false,640,480);
                FlxG.state.add(bg);
            } else if(ending == "nope") {
                bg1 = new FlxSprite(0,0);
                bg1.loadGraphic(ImgBg1,false,false,640,480);
                FlxG.state.add(bg1);

                bg2 = new FlxSprite(0,0);
                bg2.loadGraphic(ImgBg2,false,false,640,480);
                FlxG.state.add(bg2);
                bg2.visible = false;
                bg2.alpha = 0;

                bubble = new FlxSprite(50,10);
                bubble.loadGraphic(ImgBubble,false,false,528,150);
                FlxG.state.add(bubble);
                bubble.visible = false;
                bubble.alpha = 0;

                opening_text = new FlxText(60,50,500,end_string);
                opening_text.setFormat("zaguatica-Bold",20,0xffffffff,"center");
                opening_text.alpha = 0;
                FlxG.state.add(opening_text);
                end_text.visible = false;

                endTime = 3;

                if(FlxG.music == null){
                FlxG.playMusic(ClockSound);
                } else {
                    FlxG.music.resume();
                    if(!FlxG.music.active){
                        FlxG.playMusic(ClockSound);
                    }
                }
            } else if(ending == "end 3") {
                FlxG.play(LeaveSound);
                endTime = 8;
                if(timeSec == 4) {
                    end_text.visible = false;
                }
            }
            add(end_text);
        }

        override public function update():void
        {
            super.update();
            if(ending == "end 3") {
                if(timeSec == 4) {
                    end_text.visible = false;
                }
            } else if(ending == "nope") {
                if(!bg2.visible) {
                    bg2.visible = true;
                } else {
                    bg2.alpha += .03;
                }
                if(!bubble.visible) {
                    bubble.visible = true;
                } else {
                    bubble.alpha += .03;
                    opening_text.alpha += .03;
                }
            }
        }

        override public function endCallback():void {
            if(ending == "end 1"){
                FlxG.switchState(new TextState("","end 2"));
            } else if (ending == "end 2"){
                FlxG.switchState(new TextState("That's enough. We're leaving.\nGet in the car, honey.", "end 3"));
            } else if(ending == "end 3") {
                FlxG.switchState(new MenuState());
            } else if(ending == "nope"){
                FlxG.switchState(new PlayState());
            }

        }
    }
}
