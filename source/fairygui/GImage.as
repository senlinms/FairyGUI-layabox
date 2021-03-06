package fairygui {
	import fairygui.display.Image;
	
    public class GImage extends GObject implements IColorGear {
        public var image: Image;
        
        private var _color: String;
        private var _flip: int;

        public function GImage() {
            super();
            this._color = "#FFFFFF";
        }
        
        public function get color(): String {
            return this._color;
        }
        
        public function set color(value: String):void {
            if(this._color != value) {
                this._color = value;
                this.updateGear(4);
                this.applyColor();
            }
        }
        
        private function applyColor():void {
            //not supported yet
        }
        
        public function get flip():int {
            return this._flip;
        }
        
        public function set flip(value:int):void {
            if(this._flip!=value) {
                this._flip = value;
				
				var sx:Number = 1, sy:Number = 1;
                if(this._flip == FlipType.Horizontal || this._flip == FlipType.Both)
                    sx = -1;
                if(this._flip == FlipType.Vertical || this._flip == FlipType.Both)
                    sy = -1;
               	this.setScale(sx, sy);
				handleXYChanged();
            }
        }
        
		override protected function createDisplayObject(): void {
            this._displayObject = this.image = new Image();
			this.image.mouseEnabled = false;
            this._displayObject["$owner"] = this;
        }

		override public function constructFromResource(pkgItem: PackageItem): void {
            this._packageItem = pkgItem;
            pkgItem.load();
            
            this._sourceWidth = this._packageItem.width;
            this._sourceHeight = this._packageItem.height;
            this._initWidth = this._sourceWidth;
            this._initHeight = this._sourceHeight;
            this.image.scale9Grid = pkgItem.scale9Grid;
            this.image.scaleByTile = pkgItem.scaleByTile;
            this.image.texture = pkgItem.texture;
            this.setSize(this._sourceWidth, this._sourceHeight);
        }
        
		override protected function handleXYChanged(): void {
            super.handleXYChanged();
            if(this.scaleX==-1)
                this.image.x += this.width;
            if(this.scaleY==-1)
                this.image.y += this.height;
        }

		override protected function handleSizeChanged(): void {
            if(this.image.texture!=null) {
                this.image.scaleTexture(this.width/this._sourceWidth, this.height/this._sourceHeight);
            }
        }
        
		override public function setup_beforeAdd(xml: Object): void {
            super.setup_beforeAdd(xml);

            var str: String;
            str = xml.getAttribute("color");
            if(str)
                this.color = str;
                
            str = xml.getAttribute("flip");
            if(str)
                this.flip = FlipType.parse(str);	
        }
    }
}