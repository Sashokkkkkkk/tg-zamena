#include "colors.inc"
#include "textures.inc"

global_settings {
  ambient_light White
}

camera {
  location <3, 5, -13>
  look_at <3, 3, 40>
  angle 60
}

light_source {
  <10, 15, -5>
  color White
}

light_source {
  <0, 8, 0>
  color White
}

background { color NeonBlue }

plane {
  y, 0
  pigment { checker color White, color Gray20 scale 1.5 }
  finish { ambient 0.2 diffuse 0.8 }
}

// ========== СТОЛ ==========

// Левая перегородка (боковая стенка)
box {
  <-1.8, 0, -1.5>, 
  <-1.5, 1.5, 1.5>
  pigment { Gray }
  finish { phong 0.6 }
}

// Правая перегородка (боковая стенка)
box {
  <1.5, 0, -1.5>, 
  <1.8, 1.5, 1.5>
  pigment { Gray }
  finish { phong 0.6 }
}

// Столешница (основная часть — без выреза, CSG difference ниже)
difference {
  // Основная столешница
  box {
    <-1.8, 1.5, -1.5>, <1.8, 1.65, 1.5>
    pigment { color rgb <0.7, 0.5, 0.2> }
    finish { phong 0.7 reflection 0.1 }
  }
  // Вырез под провод мыши — правый нижний угол столешницы, закруглённый паз
  cylinder {
    <1.3, 1.4, 1.35>,
    <1.3, 1.7, 1.35>,
    0.08
    pigment { color rgb <0.4, 0.25, 0.08> }
  }
}

// Клавиатура
box {
  <-0.5, 1.65, -0.6>, 
  <1, 1.75, -1.1>
  texture {                  
    pigment {
      image_map {
        png "gifs/Klava.png" 
        map_type 0
        interpolate 2
      }
      scale <1.5, 0.1, 0.5>
      translate <0.25, 0, -0.25>
    }
    finish { 
      ambient 0.3 
      diffuse 0.7
    }
  }
}

// ========== МОНИТОР ==========

// Ножка монитора (цилиндр)
cylinder { 
  <0, 1.65, -0.15>, 
  <0, 2, -0.15>, 
  0.08
  pigment { Grey }
  finish { phong 0.5 }
}

// Корпус монитора (бокс)
box {
  <-1, 2, -0.1>, 
  <1, 6.4, -0.2>
  texture {                  
    pigment {
      image_map {
        png "gifs/monic.png" 
        map_type 2
        interpolate 2
        once
      }
      scale <2, 0.8, 1>
      translate <0, 2, 0>
    }
    finish { 
      ambient 0.3 
      diffuse 0.7
    }
  }
}
box {
  <-1.05, 1.95, -0.05>, 
  <1.05, 2.85, -0.18>
  pigment { Black }
  finish { phong 0.5 }
}

// Бокс (тумба) под столом слева
box {
  <0.8, 1.2, 1>, 
  <1.7, 0, -1>
  texture {                  
    pigment {
      image_map {
        png "gifs/sis.png" 
        map_type 1
        interpolate 2
        once
      }
      scale <0.6, 0.6, 1>
      translate<1.25, 0.6, 0>
    }
    finish { 
      ambient 0.3 
      diffuse 0.7
    }
  }
}

// ========== МЫШЬ (правый нижний угол стола) ==========

#declare mouse_color = color rgb <0.15, 0.15, 0.15>;
#declare mouse_highlight = color rgb <0.3, 0.3, 0.35>;

// Основное тело мыши — вытянутый сфероид
sphere {
  <1.3, 1.72, 1.0>, 1
  scale <0.18, 0.07, 0.28>
  pigment { mouse_color }
  finish { phong 0.8 specular 0.5 roughness 0.05 }
}

// Передняя часть (более узкая)
sphere {
  <1.3, 1.71, 0.78>, 1
  scale <0.13, 0.055, 0.1>
  pigment { mouse_color }
  finish { phong 0.8 specular 0.5 roughness 0.05 }
}

// Разделительная линия между кнопками (канавка сверху)
box {
  <1.295, 1.778, 0.75>,
  <1.305, 1.782, 1.05>
  pigment { color rgb <0.08, 0.08, 0.08> }
  finish { phong 0.3 }
}

// Левая кнопка мыши
sphere {
  <1.18, 1.775, 0.88>, 1
  scale <0.1, 0.015, 0.15>
  pigment { mouse_highlight }
  finish { phong 0.9 specular 0.6 roughness 0.04 }
}

// Правая кнопка мыши
sphere {
  <1.42, 1.775, 0.88>, 1
  scale <0.1, 0.015, 0.15>
  pigment { mouse_highlight }
  finish { phong 0.9 specular 0.6 roughness 0.04 }
}

// Колёсико прокрутки
cylinder {
  <1.3, 1.785, 0.88>,
  <1.3, 1.800, 0.88>,
  0.025
  pigment { color rgb <0.55, 0.55, 0.55> }
  finish { phong 1.0 }
}

// Провод мыши — идёт через вырез к задней части стола
#declare wire_r = 0.012;
cylinder {
  <1.3, 1.72, 0.72>,
  <1.3, 1.72, 1.36>,
  wire_r
  pigment { color rgb <0.1, 0.1, 0.1> }
  finish { phong 0.3 }
}
// Провод уходит в вырез (вертикальный участок)
cylinder {
  <1.3, 1.65, 1.36>,
  <1.3, 1.72, 1.36>,
  wire_r
  pigment { color rgb <0.1, 0.1, 0.1> }
  finish { phong 0.3 }
}
// Провод свисает под стол
cylinder {
  <1.3, 0.8, 1.36>,
  <1.3, 1.65, 1.36>,
  wire_r
  pigment { color rgb <0.1, 0.1, 0.1> }
  finish { phong 0.3 }
}

// ========== ЗАРЯДНИК / АДАПТЕР ==========

// Блок зарядника на столешнице (правая сторона)
// Основной корпус адаптера
box {
  <1.0, 1.65, 0.3>,
  <1.45, 1.90, 0.65>
  pigment { color rgb <0.12, 0.12, 0.14> }
  finish { phong 0.6 specular 0.3 roughness 0.08 }
}

// Скруглённые края адаптера (декоративные цилиндры по углам)
cylinder {
  <1.0, 1.65, 0.3>, <1.0, 1.90, 0.3>, 0.0
  pigment { color rgb <0.12, 0.12, 0.14> }
}

// Логотип/индикатор на адаптере (светящаяся полоска)
box {
  <1.18, 1.91, 0.35>,
  <1.27, 1.915, 0.60>
  pigment { color rgb <0.2, 0.7, 1.0> }
  finish { ambient 0.9 diffuse 0.1 }
}

// Вилка адаптера (два штырька)
cylinder {
  <1.12, 1.68, 0.66>,
  <1.12, 1.68, 0.72>,
  0.025
  pigment { color rgb <0.8, 0.8, 0.8> }
  finish { phong 1.0 metallic }
}
cylinder {
  <1.33, 1.68, 0.66>,
  <1.33, 1.68, 0.72>,
  0.025
  pigment { color rgb <0.8, 0.8, 0.8> }
  finish { phong 1.0 metallic }
}

// Кабель от адаптера (USB/зарядный)
cylinder {
  <1.0, 1.76, 0.47>,
  <0.5, 1.76, 0.47>,
  0.015
  pigment { color rgb <0.15, 0.15, 0.15> }
  finish { phong 0.4 }
}
cylinder {
  <0.5, 1.76, 0.47>,
  <0.5, 1.76, -0.2>,
  0.015
  pigment { color rgb <0.15, 0.15, 0.15> }
  finish { phong 0.4 }
}

// Коннектор USB на конце кабеля
box {
  <0.46, 1.74, -0.22>,
  <0.54, 1.78, -0.30>
  pigment { color rgb <0.7, 0.65, 0.2> }
  finish { phong 1.0 metallic }
}

// ========== СТУЛ ==========
#declare styl = union{
    box { <-8.5, -3.8, 5>,               
      < -4, -4, 10>               
      texture {                  
         pigment { wood }
      }                          
    }

    box { <-9, -10, 5>,                 
      < -8.5, 1.4, 5.5>               
      texture {                  
         pigment { color Gray } 
      }                          
    }                                 
   
    box { <-9, -10, 10>,                
      < -8.5, 1.4, 9.5>            
      texture {                  
         pigment { color Gray }
      }                          
    }
  
    box { <-3.8, -10, 10>,                
      < -10.7, -9.5, 9.5>               
      texture {                  
         pigment { color Gray }
      }                          
    }  
 
    box { <-3.8, -10, 5>,                
      <-10.7, -9.5, 5.5>               
      texture {                  
         pigment { color Gray }
      }                          
    }
   
    box { <-9, -10, 5>,                 
      <-8.5, -9.5, 10>               
      texture {                  
         pigment { color Gray }  
      }                          
    } 

    box { <-8.5, -4, 10>,                
      <-5, -4.5, 9.5>               
      texture {                  
         pigment { color Gray } 
      }                          
    }  
 
    box { <-8.5, -4, 5>,              
      <-5, -4.5, 5.5>               
      texture {                  
         pigment { color Gray } 
      }                          
    }

    box { <-8.5, -1, 5>,            
      < -8.3, 2, 10>            
      texture {                  
         pigment { wood }  
      }                          
    }   
}

object {
    styl
    scale 0.20
    translate<-1, 2, -1.5>
    rotate<0, -90, 0>
}
