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
// Мышь размещена в правом нижнем углу: x≈1.1, z≈1.15

#declare MC = color rgb <0.08, 0.08, 0.09>;   // основной чёрный
#declare MH = color rgb <0.18, 0.18, 0.20>;   // чуть светлее — кнопки
#declare MF = finish { phong 1.0 specular 0.6 roughness 0.03 }

union {
  // --- тело мыши (основной сфероид) ---
  sphere {
    <0, 0, 0>, 1
    scale <0.14, 0.065, 0.22>
    pigment { MC } finish { MF }
  }
  // --- передний скос (нос) ---
  sphere {
    <0, -0.015, -0.20>, 1
    scale <0.10, 0.045, 0.07>
    pigment { MC } finish { MF }
  }
  // --- левая кнопка ---
  sphere {
    <-0.055, 0.062, -0.06>, 1
    scale <0.068, 0.012, 0.13>
    pigment { MH } finish { MF }
  }
  // --- правая кнопка ---
  sphere {
    <0.055, 0.062, -0.06>, 1
    scale <0.068, 0.012, 0.13>
    pigment { MH } finish { MF }
  }
  // --- разделительная канавка ---
  box {
    <-0.005, 0.060, -0.20>,
    < 0.005, 0.075,  0.08>
    pigment { color rgb <0.04, 0.04, 0.04> }
    finish { phong 0.2 }
  }
  // --- колёсико ---
  cylinder {
    <0, 0.072, -0.04>,
    <0, 0.080, -0.04>,
    0.020
    pigment { color rgb <0.40, 0.40, 0.42> }
    finish { phong 1.0 }
  }
  // --- провод из носа мыши ---
  cylinder {
    <0, 0.00, -0.22>,
    <0, 0.00, -0.38>,
    0.010
    pigment { color rgb <0.08, 0.08, 0.08> }
    finish { phong 0.3 }
  }

  translate <1.1, 1.715, 1.15>
}

// Провод тянется от мыши к вырезу в столешнице
#declare WR = 0.010;
cylinder {
  <1.1, 1.715, 0.77>,
  <1.1, 1.715, 1.35>,
  WR
  pigment { color rgb <0.08, 0.08, 0.08> }
  finish { phong 0.3 }
}
// вертикальный участок — уходит в вырез
cylinder {
  <1.1, 1.650, 1.35>,
  <1.1, 1.715, 1.35>,
  WR
  pigment { color rgb <0.08, 0.08, 0.08> }
  finish { phong 0.3 }
}
// свисает под стол
cylinder {
  <1.1, 0.60, 1.35>,
  <1.1, 1.650, 1.35>,
  WR
  pigment { color rgb <0.08, 0.08, 0.08> }
  finish { phong 0.3 }
}

// ========== ЗАРЯДНИК / АДАПТЕР ==========
// Компактный чёрный кубик слева от мыши на столе

union {
  // корпус
  box {
    <-0.13, 0, -0.10>,
    < 0.13, 0.17,  0.10>
    pigment { color rgb <0.07, 0.07, 0.08> }
    finish { phong 0.7 specular 0.4 roughness 0.05 }
  }
  // индикатор (синяя точка сверху)
  sphere {
    <0.0, 0.175, 0.0>, 0.018
    pigment { color rgb <0.1, 0.6, 1.0> }
    finish { ambient 1.0 diffuse 0.0 }
  }
  // два штырька (вилка) — спереди
  cylinder {
    <-0.04, 0.06, 0.10>,
    <-0.04, 0.06, 0.14>,
    0.015
    pigment { color rgb <0.80, 0.80, 0.80> }
    finish { phong 1.0 metallic }
  }
  cylinder {
    < 0.04, 0.06, 0.10>,
    < 0.04, 0.06, 0.14>,
    0.015
    pigment { color rgb <0.80, 0.80, 0.80> }
    finish { phong 1.0 metallic }
  }
  // кабель от адаптера
  cylinder {
    <-0.13, 0.085, 0.0>,
    <-0.35, 0.085, 0.0>,
    0.012
    pigment { color rgb <0.08, 0.08, 0.08> }
    finish { phong 0.3 }
  }

  translate <0.55, 1.650, 0.50>
}

// USB-коннектор на конце кабеля адаптера
box {
  <0.16, 1.720, 0.48>,
  <0.20, 1.740, 0.52>
  pigment { color rgb <0.65, 0.55, 0.10> }
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
