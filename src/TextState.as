package
{
    import org.flixel.*;

    public class TextState extends TimedState{
        [Embed(source="../assets/new/zaguatica-Bold.otf", fontFamily="zaguatica-Bold", embedAsCFF="false")] public var GameFont:String;
        [Embed(source="../assets/glass.mp3")] private var GlassSound:Class;
        [Embed(source="../assets/new/brokenbulb.png")] private var BgImg:Class;
        [Embed(source="../assets/new/leave.mp3")] private var LeaveSound:Class;
        [Embed(source="../assets/new/TITLE_A.png")] private var ImgBg1:Class;
        [Embed(source="../assets/new/TITLE_B.png")] private var ImgBg2:Class;
        [Embed(source="../assets/new/TITLE_B_BUBBLE.png")] private var ImgBubble:Class;
        [Embed(source="../assets/new/snow.png")] private var ImgSnow:Class;
        [Embed(source="../assets/new/getout.png")] private var ImgGetOutBubble:Class;
        [Embed(source="../assets/new/endbubble.png")] private var ImgEndBubble:Class;
        [Embed(source="../assets/new/finale.png")] private var ImgEnd:Class;

        public var nextState:FlxState;
        public var ending:String;
        public var end_text:FlxText;
        public var bg1:FlxSprite;
        public var bg2:FlxSprite;
        public var bubble:FlxSprite;
        public var end_string:String;
        public var get_out_bubble:FlxSprite;
        public var end_bubble:FlxSprite;
        public var end_bg:FlxSprite;

        public var opening_text:FlxText;
        public var snow:FlxSprite;
        public var snow2:FlxSprite;
        public var snow_group:FlxGroup;
        public var snow_pos:Array;
        public var end_lock:Boolean = false;
        public var i:Number = 0;

        public function TextState(e_text:String, end:String, snowpos:Array=null) {
            super();
            end_string = e_text;
            //this.nextState = next;
            ending = end;
            FlxG.bgColor = 0xff000000;
            snow_pos = snowpos;
        }

        override public function create():void
        {
            endTime = 4;
            end_text = new FlxText(0,FlxG.height/2-10,FlxG.width,end_string);
            end_text.setFormat("zaguatica-Bold",24,0xffffffff,"center");

            if(ending == "end 1"){
                get_out_bubble = new FlxSprite(0,0);
                get_out_bubble.loadGraphic(ImgGetOutBubble,false,false,640,480);
                end_text.y = end_text.y-25;
                FlxG.state.add(get_out_bubble);
                FlxG.music.stop();
                FlxG.play(GlassSound);
            } else if(ending == "end 2") {
                FlxG.music.stop();

                var bg:FlxSprite = new FlxSprite(0,0);
                bg.loadGraphic(BgImg,false,false,640,480);
                FlxG.state.add(bg);

                get_out_bubble = new FlxSprite(0,0);
                get_out_bubble.loadGraphic(ImgGetOutBubble,false,false,640,480);
                end_text.y = end_text.y-25;
                FlxG.state.add(get_out_bubble);
            } else if(ending == "end 3") {
                FlxG.play(LeaveSound);
                endTime = 100000;

                end_bg = new FlxSprite(0,0);
                end_bg.loadGraphic(ImgEnd,false,false,640,767);
                FlxG.state.add(end_bg);

                end_bubble = new FlxSprite(50,190);
                end_bubble.loadGraphic(ImgEndBubble,false,false,528,134);
                FlxG.state.add(end_bubble);

                if(timeSec == 4) {
                    end_text.visible = false;
                }

                snow_group = new FlxGroup();

                snow = new FlxSprite(0,0);
                snow.loadGraphic(ImgSnow,false,false,573,850);
                FlxG.state.add(snow);
                snow_group.add(snow);

                snow2 = new FlxSprite(0,-850);
                snow2.loadGraphic(ImgSnow,false,false,573,850);
                FlxG.state.add(snow2);
                snow_group.add(snow2);
            }
                add(end_text);
        }

        override public function update():void
        {
            super.update();

            if(ending == "end 3") {
                if(end_bg.y + end_bg.height <= 480) {
                    if(!end_lock) {
                        timeSec = 0;
                        timeFrame = 0;
                        endTime = 2;
                        end_lock = true;
                    }
                }

                if(timeSec > 3) {
                    end_bg.y -= .7;
                    end_text.alpha -= .03;
                    end_bubble.alpha -= .03;
                }

                for(i = 0; i < snow_group.length; i++) {
                    snow_group.members[i].y += 1;
                    if(snow_group.members[i].y >= 480) {
                        snow_group.members[i].y = -850;
                    }
                }
            } else if(ending == "end 2") {
                end_text.alpha -= .01;
                get_out_bubble.alpha -= .01;
            }
        }

        override public function endCallback():void {
            if(ending == "end 1"){
                FlxG.switchState(new TextState("","end 2"));
            } else if (ending == "end 2"){
                FlxG.switchState(new TextState("That's enough. We're leaving.\nGet in the car, honey.", "end 3"));
            } else if(ending == "end 3") {
                FlxG.switchState(new MenuState(true, new Array(new FlxPoint(snow.x,snow.y), new FlxPoint(snow2.x,snow2.y))));
            }

        }
    }
}
