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

// ========== МЫШЬ (правый БЛИЖНИЙ угол стола — нижний на экране) ==========
// Ближний край стола z=-1.5, правый x=1.8 => мышь у x≈1.1, z≈-1.1

#declare MC = color rgb <0.07, 0.07, 0.08>;
#declare MH = color rgb <0.17, 0.17, 0.19>;
#declare MF = finish { phong 1.0 specular 0.7 roughness 0.03 }

union {
  // тело
  sphere {
    <0, 0, 0>, 1
    scale <0.13, 0.060, 0.21>
    pigment { MC } finish { MF }
  }
  // нос (передний скос)
  sphere {
    <0, -0.012, 0.18>, 1
    scale <0.09, 0.040, 0.06>
    pigment { MC } finish { MF }
  }
  // левая кнопка
  sphere {
    <-0.052, 0.058, 0.04>, 1
    scale <0.063, 0.011, 0.12>
    pigment { MH } finish { MF }
  }
  // правая кнопка
  sphere {
    < 0.052, 0.058, 0.04>, 1
    scale <0.063, 0.011, 0.12>
    pigment { MH } finish { MF }
  }
  // разделительная канавка
  box {
    <-0.004, 0.056, -0.18>,
    < 0.004, 0.072,  0.16>
    pigment { color rgb <0.03, 0.03, 0.03> }
    finish { phong 0.2 }
  }
  // колёсико
  cylinder {
    <0, 0.068, 0.05>,
    <0, 0.078, 0.05>,
    0.018
    pigment { color rgb <0.38, 0.38, 0.40> }
    finish { phong 1.0 }
  }
  // провод из носа мыши (к дальнему краю — в сторону увеличения z)
  cylinder {
    <0, 0, 0.22>,
    <0, 0, 0.50>,
    0.009
    pigment { color rgb <0.07, 0.07, 0.07> }
    finish { phong 0.3 }
  }

  translate <1.1, 1.715, -1.1>
}

// Провод от мыши тянется к вырезу (z=-1.35 — задняя часть стола у камеры — нет,
// вырез у z=1.35 дальнего края. Ведём провод по поверхности к центру стола)
#declare WR = 0.009;
// горизонтальный участок по столу
cylinder {
  <1.1, 1.715, -0.60>,
  <1.1, 1.715, -1.32>,
  WR
  pigment { color rgb <0.07, 0.07, 0.07> }
  finish { phong 0.3 }
}
// вертикальный — уходит в вырез (ближний край столешницы)
cylinder {
  <1.1, 1.650, -1.35>,
  <1.1, 1.715, -1.35>,
  WR
  pigment { color rgb <0.07, 0.07, 0.07> }
  finish { phong 0.3 }
}
// свисает вниз под столом
cylinder {
  <1.1, 0.50,  -1.35>,
  <1.1, 1.650, -1.35>,
  WR
  pigment { color rgb <0.07, 0.07, 0.07> }
  finish { phong 0.3 }
}

// ========== ВЫРЕЗ ПОД ПРОВОД (ближний правый край столешницы) ==========
// Уже объявлен через difference выше, но вырез там z=1.35 (дальний).
// Добавляем второй вырез — ближний правый угол x≈1.1, z≈-1.35
// Реализуем отдельной тёмной "заглушкой" поверх (имитация паза)
cylinder {
  <1.1, 1.648, -1.35>,
  <1.1, 1.652, -1.35>,
  0.07
  pigment { color rgb <0.38, 0.25, 0.08> }
  finish { phong 0.3 }
}

// ========== ЗАРЯДНИК / АДАПТЕР ==========
// Маленький чёрный кубик — на столе справа, ближе к зрителю, хорошо виден

union {
  // корпус — чёрный матовый прямоугольник
  box {
    <-0.10, 0.00, -0.08>,
    < 0.10, 0.14,  0.08>
    pigment { color rgb <0.07, 0.07, 0.08> }
    finish { phong 0.8 specular 0.5 roughness 0.04 }
  }
  // синий LED-индикатор сверху
  sphere {
    <0, 0.148, 0>, 0.016
    pigment { color rgb <0.05, 0.55, 1.0> }
    finish { ambient 1.0 diffuse 0.0 }
  }
  // два металлических штырька вилки (смотрят в сторону +z)
  cylinder {
    <-0.032, 0.055, 0.08>,
    <-0.032, 0.055, 0.13>,
    0.014
    pigment { color rgb <0.82, 0.82, 0.82> }
    finish { phong 1.0 metallic }
  }
  cylinder {
    < 0.032, 0.055, 0.08>,
    < 0.032, 0.055, 0.13>,
    0.014
    pigment { color rgb <0.82, 0.82, 0.82> }
    finish { phong 1.0 metallic }
  }
  // кабель уходит влево (-x)
  cylinder {
    <-0.10, 0.07, 0>,
    <-0.40, 0.07, 0>,
    0.011
    pigment { color rgb <0.07, 0.07, 0.07> }
    finish { phong 0.3 }
  }

  // размещаем на столе: правая сторона, ближе к зрителю
  translate <1.1, 1.650, -0.55>
}

// USB-коннектор на конце кабеля зарядника
box {
  <0.68, 1.720, -0.57>,
  <0.72, 1.738, -0.53>
  pigment { color rgb <0.65, 0.55, 0.08> }
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
    translate<-0.2, 2, 0.5>
    rotate<0, -90, 0>
}
