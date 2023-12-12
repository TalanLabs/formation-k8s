import {useState, useEffect, useRef, FunctionComponent} from 'react'
import './App.css'
import {Cat} from "./models.ts";
import * as services from "./services.ts";
import bengal from './assets/bengal.jpeg'
import angora from './assets/angora.png'
import gouttiere from './assets/gouttiere.jpeg'
import maineCoon from './assets/maine-coon.jpeg'

type RotozoomProps = {
    cat: Cat
}

const Rotozoom : FunctionComponent<RotozoomProps>= ({cat}) => {

    const tw = 256;
    const th = 256;

    const rw = 512;
    const rh = 512; 

    const textureRef = useRef<HTMLCanvasElement>(null);
    const rotozoomRef = useRef<HTMLCanvasElement>(null);

    const [textureCtx, setTextureCtx] = useState<CanvasRenderingContext2D>();

    const imageSrc = getCatImage(cat.type);

    const drawTexture = async (imageSrc: string, ): Promise<void> => {

        const canvas = textureRef.current;
        if (canvas == null) return;

        const ctx = canvas.getContext("2d");
        if (ctx == null) return;
    
        const image = new Image();
        image.src = imageSrc;
        ctx.clearRect(0, 0, tw, th);

        image.onload = () => {
            ctx.drawImage(image, 0, 0, tw, th, 0, 0, tw, th);
            setTextureCtx(ctx);
        }; 
    }

    const drawFrame = (renderCtx: CanvasRenderingContext2D, textureCtx: CanvasRenderingContext2D, a : number) => {

        const textureData = textureCtx.getImageData(0, 0, tw, th);
        const renderData = renderCtx.getImageData(0, 0, rw, rh);

        let u = 0, v = 0, ustart, vstart
        const z = Math.cos(a / 2) + 1.5, dx = Math.cos(a) * z, dy = Math.sin(a) * z;
        let i, j
    
        u = -dx * (rw / 2) + dy * (rh / 2)
        v = -dy * (rh / 2) - dx * (rw / 2)
    
        for (let y = 0; y < rh; y++) {
            ustart = u
            vstart = v
            for (let x = 0; x < rw; x++) {
                // Source
                i = (((v & 0xFF) * tw) + (u & 0xFF)) * 4;	// RGBA
                // Destination
                j = ((y * rw) + x) * 4;	// RGBA
    
                renderData.data[j] = textureData.data[i];
                renderData.data[j + 1] = textureData.data[i + 1];
                renderData.data[j + 2] = textureData.data[i + 2];
                renderData.data[j + 3] = 255;
                
                u += dx;
                v += dy;
            }
            
            u = ustart - dy;
            v = vstart + dx;
        }

        renderCtx.putImageData(renderData, 0, 0);
    } 

    useEffect(() => {
        drawTexture(imageSrc)
        
    }, [imageSrc])

    useEffect(() => {
        if (textureCtx == null) return; 

        let a = 0;

        const renderCanvas = rotozoomRef.current;
        if (renderCanvas == null) return;

        const renderCtx = renderCanvas.getContext("2d");
        if (renderCtx == null) return;

        const timer = setInterval(() => {
                a += 0.03;
                renderCtx.clearRect(0, 0, rw, rh);
                drawFrame(renderCtx, textureCtx, a);
        }, 25)
            
        return () => {
            clearInterval(timer);
        };
        

    }, [textureCtx])

    return (
        <div className="w-screen justify-center flex my-10">
            <div className="hidden">
                <canvas ref={textureRef} width={tw} height={th}></canvas>
            </div>
            <div className={"w-[" + rw + "px] h-[" + rh + "px]"}>
                <canvas ref={rotozoomRef} width={rw} height={rh}></canvas>
            </div>
        </div> 
    
    )
}

function App() {
  const [cats, setCats] = useState<Cat[]>([])
  const [selectCat, setSelectCat] = useState<Cat>();


  const addCats = async () => {

       await services.addCat()
       const cats = await services.getCats();
       setCats(cats);

  }

  useEffect(() => {
      services.getCats()
          .then(cats => setCats(cats))
  }, [])

  return (
    <div className="h-full w-screen justify-between flex flex-col p-5">
        <div className="flex flex-col">
                <div className="flex gap-1 col-auto w-full justify-around text-[#D46F4D] font-extrabold">
                    <span> name </span>
                    <span> type</span>
                    <span> age </span>
                    <span> photo </span>
                </div>
            {cats.map(cat => (
                <div className="flex gap-1 col-auto w-full justify-around text-black" key={cat.id}>
                    <span>{cat.name}</span>
                    <span>{cat.type}</span>
                    <span>{cat.age}</span>
                    <a onClick={() => setSelectCat(cat)}  className="cursor-pointer">
                        <img alt={'cat picture'} src={getCatImage(cat.type)}></img>
                    </a>
                    
                </div>
            ))}
        </div>
        <div className="bottom-0 flex justify-around">
            <button className="bg-[#09C5D1] text-black font-bold py-2 px-2 rounded-xl cursor-pointer" onClick={() => addCats()}> click here to add a cat </button>
        </div>
        {
            (selectCat) ? (
                <Rotozoom cat={selectCat}></Rotozoom>
            ) : ""
        }
    </div>
  )
}

const getCatImage = (type: string) => {
    switch (type) {
        case 'Bengal':
            return bengal
        case 'Angora':
            return angora
        case 'Maine coon':
            return maineCoon
        case 'Gouttière':
        default:
            return gouttiere
    }
}

export default App
