stop();

////////Importación de paquetes para generar efectos////////
import gs.*;
import gs.easing.*;
import gs.plugins.*;
TweenPlugin.activate([ColorTransformPlugin, TintPlugin]);
//////**Importación de paquetes para generar efectos**//////

////////Definición de variables////////
var nImagenes:Number;
var totalImagenes:Number;
var nFilas:Number;
var nColumnas:Number;
var cronometro:Number;
var segundos:Number;
var primerPaso:Boolean;
var limiteParejas:Number;
var arregloImagenes:Array;
var juego:Array;
var actividadPerdida:Boolean;
var tablero:Array;
var parejasFormadas:Number;

//////**Definición de variables**//////

iniciar();

function iniciar(){
	limiteParejas = 1;
	nImagenes = 6;
	totalImagenes = nImagenes * 2;
	nFilas = 4;
	nColumnas = 3;
	primerPaso = true;
	actividadPerdida = false;
	parejasFormadas = 0;
	
	
	Breiniciar.enabled = false;
	Breiniciar._visible = false;
	
	arregloImagenes = new Array(nImagenes);
	for(var i = 0;i<arregloImagenes.length;i++){
		arregloImagenes[i] = 0;
		_root["r"+(i+1)].orix = _root["r"+(i+1)]._x;
		_root["r"+(i+1)].oriy = _root["r"+(i+1)]._y;
		
		_root["r"+(i+1)].desx = _root["r"+(i+1)]._x;
		_root["r"+(i+1)].desy = _root["r"+(i+1)]._y + 100;
	}
	
	if((nFilas*nColumnas/2)%2 == 0){	
		var posx:Number = 0;
		var posy:Number = 0;
		
		tablero = new Array(nFilas);
		//We call the cube function
		//generateCube();
		
		asignarImagenes();		
		
		for(var i=0;i<tablero.length;i++){
			var fichaNueva:MovieClip = new MovieClip();
			for(var j=0;j<tablero[0].length;j++){
				fichaNueva = Ctablero.attachMovie("ficha","ficha"+i+""+j,Ctablero.getNextHighestDepth());
				//Ctablero["ficha"+i+""+j].attachMovie("figura"+(j+1),"frente",Ctablero["ficha"+i+""+j].getNextHighestDepth());
				
				Ctablero["ficha"+i+""+j].numero = tablero[i][j];
				Ctablero["ficha"+i+""+j].attachMovie("figura"+tablero[i][j],"frente",Ctablero["ficha"+i+""+j].getNextHighestDepth());
				
				//asignarFrente(Ctablero["ficha"+i+""+j]);
				Ctablero["ficha"+i+""+j].attachMovie("espalda","espalda",Ctablero["ficha"+i+""+j].getNextHighestDepth());
				Ctablero["ficha"+i+""+j].espalda._alpha = 0;
				Ctablero["ficha"+i+""+j]._x = posx;
				Ctablero["ficha"+i+""+j]._y = posy;
				Ctablero["ficha"+i+""+j].estaQuieta = true;
				Ctablero["ficha"+i+""+j].deFrente = true;
				Ctablero["ficha"+i+""+j].enabled = false;
				Ctablero["ficha"+i+""+j].usada = false;
				Ctablero["ficha"+i+""+j].onRollOver = function(){
					TweenMax.to(this,0.28,{colorTransform:{exposure:1.4,brightness:1.35}, ease:Quart.easeOut});
				}
				Ctablero["ficha"+i+""+j].onRollOut = function(){
					TweenMax.to(this,0.7,{colorTransform:{exposure:1,brightness:1}, ease:Quart.easeOut});
				}
				Ctablero["ficha"+i+""+j].onRelease = Ctablero["ficha"+i+""+j].onReleaseOutside = function(){
					voltearFicha(this);
				}
				//Ctablero["ficha"+i+""+j].generateCube();
				//Ctablero["ficha"+i+""+j].voltear();
				//fichaNueva
				posx += 70;
			}
			posx = 0;
			posy += 70;
		}
	}
	segundos = 3;
	cronometro = setInterval(tiempo, 1000);
	
	juego = new Array();
}

function asignarImagenes(){
	for(var i=0;i<tablero.length;i++){
		tablero[i] = new Array(nColumnas);
		for(var j=0;j<tablero[0].length;j++){
			var listo:Boolean = false;
			var nImagen:Number = -1;
			while(!listo){
				nImagen = numeroAleatorio(1,nImagenes);
				if(arregloImagenes[nImagen - 1] <= limiteParejas){
					listo = true;
				}
			}
			arregloImagenes[nImagen - 1] += 1;
			tablero[i][j] = nImagen;
		}
	}
	
	for(var i=0;i<tablero.length;i++){
		var fila:String = "";
		for(var j=0;j<tablero[0].length;j++){
			var temp:Number = -1;
			if(tablero[i][j] == tablero[i][j-1] || tablero[i][j] == tablero[i][j+1]){//Es igual al de atrás
				temp = tablero[i][j];
				if(tablero[i+1][j] != undefined){
					tablero[i][j] = tablero[i+1][j];
					tablero[i+1][j] = temp;
				}
				else{
					tablero[i][j] = tablero[i-1][j];
					tablero[i-1][j] = temp;
				}
			}
			else if(tablero[i][j] == tablero[i+1][j] || tablero[i][j] == tablero[i-1][j]){//Es igual al de abajo
				temp = tablero[i][j];
				if(tablero[i][j+1] != undefined){
					tablero[i][j] = tablero[i][j+1];
					tablero[i][j+1] = temp;
				}
				else{
					tablero[i][j] = tablero[i][j-1];
					tablero[i][j-1] = temp;
				}
			}
			fila += " "+tablero[i][j];
		}
		//trace(fila);
	}
}

function numeroAleatorio(min:Number, max:Number):Number {
    var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
    return randomNum;
}

function tiempo(){
	segundos--;
	if(!primerPaso){
		Ctemporizador.texto.text = "00:";
		if(segundos < 0)
			segundos = 0;
		if(segundos < 10){
			Ctemporizador.texto.textColor = 0xFF0000;
			Ctemporizador.texto.text += "0";
		}
		Ctemporizador.texto.text += segundos;
	}
	if(segundos <= 0){
		//En el primer paso se voltean las fichas
		if(primerPaso){
			primerPaso = false;
			clearInterval(cronometro);
			voltearFichas();			
			segundos = 81;
			cronometro = setInterval(tiempo, 1000);
			TweenMax.to(Ctemporizador,0.5,{_alpha:100,ease:Sine.easeOut});
		}
		//En el segundo paso, se acaba el tiempo de juego
		else{
			clearInterval(cronometro);
			pierdeActividad();
		}
	}
}

function voltearFicha(ficha:MovieClip){
	//ficha.onRelease = null;
	if(!ficha.usada){
		if(ficha.estaQuieta){
			ficha.listo = false;
			ficha.estaQuieta = false;
			ficha.voltear();
		}
	}
	else{
		mostrarRetro(ficha.numero);
	}
}

function voltearFichas(){
	for(var i=0;i<tablero.length;i++){
		for(var j=0;j<tablero[0].length;j++){
			Ctablero["ficha"+i+""+j].voltear();
		}
	}
}

function acabaVolteo(ficha:MovieClip){
	if(!actividadPerdida)
		ficha.enabled = true;
	ficha.estaQuieta = true;
	if(Ctablero[ficha._name].deFrente == true)
		Ctablero[ficha._name].deFrente = false;
	else
		Ctablero[ficha._name].deFrente = true;
	
	if(Ctablero[ficha._name].deFrente){
		if(!ficha.usada){
			juego.push(ficha);
			evaluarTablero();
		}
	}
	else
		juego.shift();
}

function evaluarTablero(){
	if(juego[1] != undefined){
		if(juego[0].numero == juego[1].numero){
			juego[0].usada = true;
			juego[1].usada = true;
			parejasFormadas++;
			mostrarRetro(juego[0].numero);
			//juego.shift();
			//juego.shift();
		}
		else{
			voltearFicha(juego[0]);
			voltearFicha(juego[1]);
		}
		juego.shift();
		juego.shift();
		evaluarTablero();
	}
}

function mostrarRetro(numero:Number){
	for(var i = 1;i<=nImagenes;i++){
		if(i == numero)
			TweenMax.to(_root["r"+i],0.5,{_alpha:100,_x:_root["r"+i].orix,_y:_root["r"+i].oriy,ease:Sine.easeOut});
		else
			TweenMax.to(_root["r"+i],0.5,{_alpha:0,_x:_root["r"+i].desx,_y:_root["r"+i].desy,ease:Sine.easeOut});
	}
	//trace(parejasFormadas);
	if(parejasFormadas == nImagenes){
		clearInterval(cronometro);
		TweenMax.to(Factividad,0.5,{_alpha:100,ease:Sine.easeOut});
	}
}

function pierdeActividad(){
	actividadPerdida = true;
	for(var i=0;i<tablero.length;i++){
		for(var j=0;j<tablero[0].length;j++){
			Ctablero["ficha"+i+""+j].enabled = false;
		}
	}
	TweenMax.to(Breiniciar,0.5,{_alpha:100,enabled:true,_visible:true,ease:Sine.easeOut});
}
function reiniciarActividad(){
	
	Ctemporizador.texto.text = "";
	
	for(var i=0;i<tablero.length;i++){
		for(var j=0;j<tablero[0].length;j++){
			//trace("aaa");
			Ctablero["ficha"+i+""+j].removeMovieClip();
		}
	}
	
	iniciar();
}


Breiniciar.onRollOver = function(){
	TweenMax.to(this,0.28,{colorTransform:{exposure:1.08,brightness:1.35}, ease:Quart.easeOut});
}
Breiniciar.onRollOut = function(){
	TweenMax.to(this,0.7,{colorTransform:{exposure:1,brightness:1}, ease:Quart.easeOut});
}
Breiniciar.onRelease = Breiniciar.onReleaseOutside = function(){
	TweenMax.to(Breiniciar,0.5,{_alpha:0,enabled:false,_visible:false,ease:Sine.easeOut});
	reiniciarActividad();
}