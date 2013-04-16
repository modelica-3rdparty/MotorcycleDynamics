package MotorcycleDynamics 
  
annotation (
Documentation(info="<HTML>
<TITLE>Motorcycle Dynamics</TITLE>
<p>
<H1>Motorcycle Dynamics Library</H1>
<p align=\"justify\">
<br>
<p>
 
The MotorcycleDynamics package is free software.<br><br>
 
Licensed by Filippo Donida under the Modelica License 2
Copyright &copy; 2002-2006, Politecnico di Milano.<br><br>
 
This Modelica package is free software and the use is completely at your own risk;<br>
it can be redistributed and/or modified under the terms of the Modelica license 2,<br>
see the license conditions (including the disclaimer of warranty)<br>
here or at http://www.modelica.org/licenses/ModelicaLicense2.
 
<br><br>
Main Authors:
 
<ul>
   <li><b>Filippo Donida</b><br>
   Politecnico di Milano<br>
   Dipartimento di Elettronica ed Informazione<br>
   viale Ponzio 34/5<br>
   20133 Milano<br>
   Italy<br>
   email: donida@elet.polimi.it<br><br>
   <li><b>Gianmario Fontana</b><br>
   email: gianmario_fontana@libero.it<br><br>
   <li><b>Francesco Schiavo</b><br>
</ul>
 Release Notes: version 1.0.1 (2006) <br>
 First official version of the library released. Copyright (C) 2002 - 2006, Politecnico di Milano
 
</p>
<br>
 
<br>
  This library is used to model <B>motorcycle chassis</B>. <br>This library model complexes phenomenons that they characterize
 the vehicles dynamics with two wheel.<br>The modeling process of physical reality has made to emerge three principal entity:  
<ul>
    <li><b>Body</b>: it understands the pilot end the chassis of motorcycle (suspension, wheel, steering gear,...);
    <br><br>
    <li><b>Road</b>: it is the modelling of road where the motorcycle stir;
    <br><br>
    <li><b>Wheel-road interaction</b>: it interface the two preceding components, it simulate present forces of contact
  </ul>
<br>
 <H3>Hierarchical levels </H3> <p>The library is based on a
hierarchical structure within the total model. This is done to
give a clear overview of the model and simplify reusage of
components.</p>
 
</HTML>"),
uses(Modelica(version="2.2.1")));
  
  model Motorcycle 
    
  annotation (
  Documentation(info="<html>
<p>The model <em>Motorcycle</em> connect all motorbike component: loom, suspension, wheels... In the picture is represented the general
  schema of the model, where it is possible to observe all sub-system that make up the motorbike. The arrows indicate the existing connections
  between various component. The road class is without connection because the motorcycle is thougt as a body that <em>navigate</em> in the air.
  <br><br>
  The process of abstraction has identified like fundamental body characteristics of a motorcycle: the geometries,
  the weight and the inertia of the various components. Macroscopically the structure can be divided in different fundamental entities:
  <ul>
    <li><b>Chassis: </b> it include loom, the rotational joint that symbolize steering gear and handlebar;
    <br>
    <li><b> Front suspension:</b> it is represented by a couple of spring-damper system with a non-linear caratteristic that is customable. 
            It is connected with the rotational joint and hub of front wheel;
    <br>
    <li><b>Rear suspension:</b> it is costituted by a single spring-dumper system sets in parallel, both with non-linear caracteristic that
           that is customable;
    <br>
    <li><b>Rear arm:</b> it connect the chassis with the hub of rear wheel;
    <br>
    <li><b>Front/Rear brake:</b> it is constituted by disk brake with pneumatic realization;
    <br>
    <li><b>Wheel:</b> it contains to it inside the model of interaction with the ground;
    <br>
    <li><b>Pilot:</b> it represents the pilot and it contanins to it inside the center of mass
           and the inertia of the superior and inferior part of this and the control laws of the motorcycle.
  </ul>
  The dynamic behavior, even if influenced by the guide style and  the pilot's reflexes, it is characterized by the particular motorbike.
</HTML>"));
    import MotorcycleDynamics.*;
    parameter Real xyz_init[3]={0,0,0} "Initial position of the rear wheel";
    Modelica.Mechanics.MultiBody.Types.Color color={0,0,0};
    parameter Wheel.Data.Base_Wheel_Data Rear_Wheel_data;
    parameter Wheel.Data.Base_Wheel_Data Front_Wheel_data;
  public 
    parameter Base_Dimension_MassPosition_Data Dimension_MassPosition_data 
      annotation (extent=[-100,80; -80,100]);
  public 
    Chassis.Standard_Chassis Standard_Chassis1(
      Steer_to_Seaddle={Dimension_MassPosition_data.E_dx,0,
          Dimension_MassPosition_data.E_dy},
      Chassis_MassPosition_From_Seaddle={-Dimension_MassPosition_data.I_dx,0,-
          Dimension_MassPosition_data.I_dy},
      Lower={Dimension_MassPosition_data.L_dx,0,-Dimension_MassPosition_data.
          L_dy},
      P={Dimension_MassPosition_data.P_dx,0,Dimension_MassPosition_data.P_dy}) 
      annotation (extent=[-20,-44; 34,6]);
    annotation (Diagram, Icon(Bitmap(extent=[-202, 126; 276, -156], name=
              "images/Moto.gif")));
    Modelica.Mechanics.Rotational.Interfaces.Flange_a Steering 
      annotation (extent=[122, 86; 136, 100]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Saddle1 
      annotation (extent=[-32, 6; -10, 20], rotation=90);
    Modelica.Mechanics.Rotational.Interfaces.Flange_a Rear_Joint 
      annotation (extent=[-132,-94; -118,-80]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_a Front_Joint 
      annotation (extent=[210,-68; 222,-56]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_rear_hub1 
      annotation (extent=[-126,-80; -106,-60]);
    Rear_Swinging_Arm.Rear_Swinging_Arm Rear_Swinging_Arm1(xyz_init=xyz_init,
        Dimension_MassPosition_data=Dimension_MassPosition_data) 
      annotation (extent=[-56,-56; -22,-32]);
    Modelica.Blocks.Interfaces.RealOutput Sensor[6] 
      annotation (extent=[-186,-128; -164,-110]);
    Wheel.Friction_Model.Interfaces.Friction_Connector Pin1 annotation (extent=[-140,
          -154; -120,-134]);
    Wheel.Friction_Model.Interfaces.Friction_Connector Pin2 annotation (extent=[202,-120;
          222,-100]);
    Suspension.Rear_Suspension.Standard_Rear_Suspension 
      Standard_Rear_Suspension(Seaddle_to_Rear_Suspension_Up={
          Dimension_MassPosition_data.H_dx,0,-Dimension_MassPosition_data.H_dy},
        M={-Dimension_MassPosition_data.M_dx,0,Dimension_MassPosition_data.M_dy},
      Rear_Suspension_data=Rear_Suspension_data) 
                                annotation (extent=[-40,-36; -20,-16]);
    Wheel.Standard_Wheel Front_Wheel(Wheel_data=Front_Wheel_data,
        Pacejka_Friction_Data=Front_Pacejka_Friction_Data) 
                      annotation (extent=[204,-72; 226,-50]);
    Wheel.Standard_Wheel Rear_Wheel(Wheel_data=Rear_Wheel_data,
        Pacejka_Friction_Data=Rear_Pacejka_Friction_Data) 
                                         annotation (extent=[-124,-100; -104,
          -78]);
    Suspension.Front_Suspension.Standard_Front_Suspension 
      Standard_Front_Suspension(Fork_r_CM={Dimension_MassPosition_data.C_dx,0,-
          Dimension_MassPosition_data.C_dy}, Steering_r_CM={
          Dimension_MassPosition_data.D_dx,0,Dimension_MassPosition_data.D_dy},
      Front_Suspension_data=Front_Suspension_data) 
                                             annotation (extent=[46,-38; 92,12]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_front_hub1 
      annotation (extent=[214,-54; 246,-34]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_b Pressure_center 
      annotation (extent=[38,58; 58,78]);
    Modelica.Blocks.Interfaces.RealInput Rear_Brake1 
      annotation (extent=[-32,-64; -12,-44]);
    Modelica.Blocks.Interfaces.RealInput Front_Brake1 
      annotation (extent=[100,82; 120,102], rotation=180);
    
    parameter Wheel.Friction_Model.Pacejka.Data.Base_Pacejka_Friction_Data 
      Rear_Pacejka_Friction_Data 
      "Relaxation Pacejka Friction Model Coefficient (They dipend from specific tyre). You must insert it even if you're using linear model instead.";
    parameter Wheel.Friction_Model.Pacejka.Data.Base_Pacejka_Friction_Data 
      Front_Pacejka_Friction_Data 
      "Relaxation Pacejka Friction Model Coefficient (They dipend from specific tyre). You must insert it even if you're using linear model instead.";
    parameter Suspension.Front_Suspension.Data.Base_Front_Suspension_Data 
      Front_Suspension_data "Front Suspension Data";
    parameter Suspension.Rear_Suspension.Data.Base_Rear_Suspension_Data 
      Rear_Suspension_data "Rear Suspension Data";
  equation 
    connect(frame_Saddle1, Standard_Chassis1.frame_Saddle) annotation (points=[-21,13;
          -8.93,13; -8.93,-12.75],      style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Rear_Joint, Rear_Swinging_Arm1.Rear_Joint) annotation (points=[-125,-87;
          -125,-47.12; -62.46,-47.12],        style(color=0, rgbcolor={0,0,0}));
    connect(Rear_Swinging_Arm1.to_Chassis, Standard_Chassis1.to_Swinging_Arm) 
      annotation (points=[-20.64,-38.72; -20.64,-34; -14.6,-34],        style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Front_Wheel.Pin, Pin2) annotation (points=[206.42,-70.9; 206.42,
          -77.35; 212,-77.35; 212,-110], style(color=3, rgbcolor={0,0,255}));
    connect(Standard_Chassis1.frame_rear_suspension_up, Standard_Rear_Suspension.
      frame_up)                           annotation (points=[-17.84,-19.5;
          -21.27,-19.5; -21.27,-17.4; -27.4,-17.4],
                                                  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Standard_Rear_Suspension.frame_down, Rear_Swinging_Arm1.
      frame_rear_suspension_down) annotation (points=[-34.8,-34.4; -34.8,-37.2;
          -35.6,-37.2; -35.6,-40.88], style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Rear_Wheel.frame_hub, Rear_Swinging_Arm1.frame_rear_hub) 
      annotation (points=[-114.4,-89.66; -58.72,-89.66; -58.72,-47.12],
                                                                     style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Standard_Front_Suspension.Steering, Steering)  annotation (points=[
          52.9,9.5; 129,9.5; 129,93], style(color=0, rgbcolor={0,0,0}));
    connect(Standard_Chassis1.frame_Steering, Standard_Front_Suspension.
      frame_front_suspension) annotation (points=[33.46,4; 40.81,4; 40.81,9.5;
          45.54,9.5], style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Standard_Front_Suspension.Front_Joint, Front_Joint)  annotation (
        points=[63.02,-35.5; 63.02,-62; 216,-62],          style(color=0,
          rgbcolor={0,0,0}));
    connect(Rear_Wheel.Pin, Pin1);
    connect(Standard_Chassis1.to_Aerodynamics, Pressure_center) annotation (
        points=[5.38,-5; 5.38,27.5; 48,27.5; 48,68],  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Rear_Swinging_Arm1.Rear_Brake, Rear_Brake1) annotation (points=[-52.6,
          -47.12; -31.3,-47.12; -31.3,-54; -22,-54],     style(color=74,
          rgbcolor={0,0,127}));
    connect(Standard_Front_Suspension.Front_Brake, Front_Brake1)  annotation (
        points=[48.3,-28; 110,-28; 110,92], style(color=74, rgbcolor={0,0,127}));
    connect(Rear_Wheel.Sensor, Sensor) annotation (points=[-105,-98.9; -105,-119; -175,
          -119], style(color=74, rgbcolor={0,0,127}));
    connect(Rear_Wheel.frame_hub, frame_rear_hub1) annotation (points=[-114.4,
          -89.66; -116,-72; -116,-70], style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
    connect(Front_Wheel.frame_hub, Standard_Front_Suspension.frame_front_hub) 
      annotation (points=[214.56,-61.66; 214.56,-35.5; 69.46,-35.5], style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
    connect(Front_Wheel.frame_hub, frame_front_hub1) annotation (points=[214.56,
          -61.66; 215.28,-61.66; 215.28,-44; 230,-44], style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
  end Motorcycle;
  
  record Base_Dimension_MassPosition_Data 
    
  annotation (
  Documentation(info="<html>
<p> This record contains the data related to the pilot and the dimensions of the various components of the motorbike
    over that the position of the center of mass. 
</HTML>"));
    
      annotation (
      defaultComponentName="Dimension_MassPosition_data",
      defaultComponentPrefixes="inner",
      Icon);
    parameter Real C_dx = 0.294 
      "Distance from steer to front suspension mass position (delta x) [m]";
    parameter Real C_dy = 0.438 
      "Distance from steer to front suspension mass position (delta y) [m]";
    parameter Real D_dx = 0.034 
      "Distance from steer to front steer mass position (delta x) [m]";
    parameter Real D_dy = 0.097 
      "Distance from steer to front steer mass position (delta y) [m]";
    parameter Real E_dx = 0.541 
      "Distance from steer to seaddle frame (delta x) [m]";
    parameter Real E_dy = 0.273 
      "Distance from steer to seaddle frame (delta y)[m]";
    parameter Real F_dx = 0.296 
      "Distance from seaddle to lower body mass position (delta x) [m]";
    parameter Real F_dy = 0.134 
      "Distance from seaddle to lower body mass position (delta y) [m]";
    parameter Real G_dx = 0.015 
      "Distance from seaddle to upper body mass position (delta x) [m]";
    parameter Real G_dy = 0.250 
      "Distance from seaddle to upper body mass position (delta y) [m]";
    parameter Real H_dx = 0.068 
      "Distance from seaddle to upper attachment of rear suspension (delta x) [m]";
    parameter Real H_dy = 0.109 
      "Distance from seaddle to upper attachment of rear suspension (delta y) [m]";
    parameter Real I_dx = 0.120 
      "Distance from steer frame to chassis mass position (delta x) [m]";
    parameter Real I_dy = 0.683 
      "Distance from steer frame to chassis mass position (delta y) [m]";
    parameter Real L_dx = 0.471 
      "Distance from rear swinging arm joint to lower front chassis (delta x) [m]";
    parameter Real L_dy = 0.134 
      "Distance from rear swinging arm joint to lower front chassis (delta y) [m]";
    parameter Real M_dx = 0.105 
      "Distance from rear swinging arm joint to lower attachment of rear suspension (delta x) [m]";
    parameter Real M_dy = 0.013 
      "Distance from rear swinging arm joint to lower attachment of rear suspension (delta y) [m]";
    parameter Real N_dx = 0.503 
      "Distance from rear wheel hub to rear swinging arm joint (delta x) [m]";
    parameter Real N_dy = 0.134 
      "Distance from rear wheel hub to rear swinging arm joint (delta y) [m]";
    parameter Real O_dx = 0.418 
      "Distance from rear wheel hub to rear swinging arm mass position (delta x)[m]";
    parameter Real O_dy = 0.080 
      "Distance from rear wheel hub to rear swinging arm mass position (delta y)[m]";
    parameter Real P_dx = 0.024 
      "Distance from lower front end chassis to steer joint (delta x)[m]";
    parameter Real P_dy = 0.750 
      "Distance from lower front end chassis to steer joint (delta y)[m]";
  end Base_Dimension_MassPosition_Data;
  
  record Supermotard_Dimension_MassPosition_Data 
    
  annotation (
  Documentation(info="<html>
<p> This record contains the data relative  to a particular type of motorcycle. 
</HTML>"));
    
    extends Base_Dimension_MassPosition_Data(
      C_dx = 0.294,
      C_dy = 0.438,
      D_dx = 0.034,
      D_dy = 0.097,
      E_dx = 0.541,
      E_dy = 0.273,
      F_dx = 0.296,
      F_dy = 0.134,
      G_dx = 0.015,
      G_dy = 0.250,
      H_dx = 0.068,
      H_dy = 0.109,
      I_dx = 0.120,
      I_dy = 0.683,
      L_dx = 0.471,
      L_dy = 0.134,
      M_dx = 0.105,
      M_dy = 0.013,
      N_dx = 0.503,
      N_dy = 0.134,
      O_dx = 0.418,
      O_dy = 0.080,
      P_dx = 0.024,
      P_dy = 0.750);
      annotation (
      defaultComponentName="Dimension_MassPosition_data");
    
  end Supermotard_Dimension_MassPosition_Data;
  
  package Braking_System 
    "This class contains the bracking system of a motorcycle" 
  annotation (
  Documentation(info="<html>
<p> This class contain the ABS system for bracking system. 
</HTML>"));
    
    model ABS 
      import Modelica.Constants.*;
      import Modelica.Math.*;
    //parameter Real n1=14;
    //parameter Real n2=50;
    parameter Real best_slip=0.11;
    parameter Real Hz=20 "Banda Passante Freni [Hz]";
        Modelica.Blocks.Continuous.TransferFunction TF(b={1}, a={1/Hz,1}) 
          annotation (extent=[54,0; 74,20]);
        Modelica.Blocks.Interfaces.RealOutput to_Brake 
          annotation (extent=[80,0; 100,20]);
      Wheel.Friction_Model.Interfaces.Friction_Connector Slip 
        annotation (extent=[-100,80; -80,100]);
      Modelica.Blocks.Interfaces.RealInput u annotation (extent=[-100,0; -80,20]);
    equation 
      connect(TF.y, to_Brake)                              annotation (points=[75,10;
            90,10],          style(color=74, rgbcolor={0,0,127}));
      annotation (Diagram);
    TF.u=(0.5+atan(((Slip.slip+1)-(1-best_slip))*10^4)/pi)*u; //(TimeTable1.y*(Slip.slip+1))^n1*(1-abs(Slip.sideslip))^n2;//if Slip.slip<-0.2 then 0 else TimeTable1.y;
    end ABS;
  end Braking_System;
  
package Chassis 
    "This class contains the standard chassis structure and the relative dimensional data. It is possible to define new chassis." 
  model Standard_Chassis "Standard model of chassis." 
      
  parameter Modelica.SIunits.Position Steer_to_Seaddle[3]={0.541,0,0.273} 
        "{E_dx,0,E_dy}";
    parameter Modelica.SIunits.Position Chassis_MassPosition_From_Seaddle[3]={-0.120,
        0,-0.683} "Center of Mass (respect to steer joint)  {-I_dx,0,-I_dy}";
    parameter Modelica.SIunits.Position Lower[3]={0.471,0,-0.134} 
        "Lower {L_dx,0,-L_dy}";
    parameter Modelica.SIunits.Position P[3]={0.025,0,0.75} "{P_dx,0,P_dy}";
      
    annotation (
      uses(                            Modelica(version="1.6")),
      Diagram,
      Icon(Bitmap(extent=[-248, 150; 114, -120], name="images/Chassis.gif")),
      experiment,
      experimentSetupOutput);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape3(
      width=0.045,
      m=0,
      animateSphere=false,
      color=Chassis_data.color,
      r={Lower[1] - 0.08,0,0},
        animation=Chassis_data.animation) 
                           annotation (extent=[46,-54; 60,-42]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape4(
      width=0.045,
      m=0,
      animateSphere=false,
        color=Chassis_data.color,
      r=P,
        animation=Chassis_data.animation) 
                           annotation (extent=[88,-12; 102,6], rotation=90);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape6(
      width=0.045,
      m=0,
      animateSphere=false,
      r={0.046,0,-0.342},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[-40,-14; -24,6],  rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape7(
      r_CM={0.35,0,-0.1},
      r={0.8,0,-0.2},
      width=0.045,
      m=0,
      animateSphere=false,
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[-110,46; -90,66],   rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape8(
      width=0.045,
      m=0,
      animateSphere=false,
        r=Steer_to_Seaddle + {-0.08,0,0},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[-18,20; -2,34]);
    Modelica.Mechanics.MultiBody.Visualizers.FixedFrame Motorcycle_Chassis(
      color_x={255,255,0},
      color_y={255,255,0},
      color_z={255,255,0},
      length=0.2,
      animation=Chassis_data.animation) 
                           annotation (extent=[48,68; 58,78],   rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape LeftPedal(
      r={0,0.18,0},
      r_CM={0,0.09,0},
      width=0.045,
      m=0,
      animateSphere=false,
        color={20,20,20},
        animation=Chassis_data.animation) 
      annotation (extent=[-40,-86; -22,-74],   rotation=180);
    Modelica.Mechanics.MultiBody.Parts.BodyShape RightPedal(
      width=0.045,
      r={0,0.18,0},
      r_CM={0,0.09,0},
      m=0,
      animateSphere=false,
        color={20,20,20},
        animation=Chassis_data.animation) 
                           annotation (extent=[10,-87; 28,-75],   rotation=180);
    Modelica.Mechanics.MultiBody.Parts.Body Mass_Inertia(
        cylinderDiameter=0,
        sphereDiameter=0.08,
        sphereColor={150,150,20},
        r_CM=Chassis_MassPosition_From_Seaddle,
      m=Chassis_data.m,
      I_11=Chassis_data.I_11,
      I_22=Chassis_data.I_22,
      I_33=Chassis_data.I_33,
      I_21=Chassis_data.I_21,
      I_31=Chassis_data.I_31,
      I_32=Chassis_data.I_32) 
                           annotation (extent=[6,46; 26,66], rotation=180);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape1(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0,0,Lower[3]},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[-40,-44; -24,-28], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape2(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0,0.1,0},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[-22,0; -6,14]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape5(
      width=0.045,
      m=0,
      animateSphere=false,
        color=Chassis_data.color,
      r=P,
        animation=Chassis_data.animation) 
                           annotation (extent=[112,-12; 126,6],rotation=90);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape9(
      width=0.045,
      m=0,
      animateSphere=false,
        r={Lower[1] - 0.08,0,0},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[46,-70; 60,-58]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape10(
      width=0.045,
      m=0,
      animateSphere=false,
      r={0.046,0,-0.342},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[26,-22; 42,-2],   rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape11(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0,0.1,0},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[4,0; 20,14]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape12(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0,0.1,0},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[-24,-28; -8,-14]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape13(
      r_CM={0.35,0,-0.1},
      r={0.8,0,-0.2},
      width=0.045,
      m=0,
      animateSphere=false,
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[-110,70; -90,90],   rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape14(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0.08,0.1,0},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[100,32; 116,46], rotation=180);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape15(
      width=0.045,
      m=0,
      animateSphere=false,
      color=Chassis_data.color,
      r={0,0,Lower[3]},
        animation=Chassis_data.animation) 
                           annotation (extent=[26,-44; 42,-28],   rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape16(
      width=0.045,
      m=0,
      animateSphere=false,
        r=Steer_to_Seaddle + {-0.08,0,0},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[42,8; 58,22]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape18(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0.08,-0.1,0},
      color=Chassis_data.color,
        animation=Chassis_data.animation) 
                           annotation (extent=[66,34; 82,48], rotation=0);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Saddle 
      annotation (extent=[-70,12; -48,38],  rotation=180);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_rear_suspension_up 
      annotation (extent=[-102,-12; -82,8], rotation=180);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a to_Swinging_Arm 
      annotation (extent=[-90,-70; -70,-50]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_Steering 
                                          annotation (extent=[86,84; 110,100]);
    protected 
    Data.Base_Chassis_Data Chassis_data 
      annotation (extent=[-100,-100; -80,-80],
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial);
    public 
    Modelica.Mechanics.MultiBody.Parts.BodyShape Pressure_Center(
        m=0,
        animateSphere=true,
        sphereDiameter=0.03,
        sphereColor={155,0,0},
        animation=true,
        length=0,
        r={0.3,0,-0.1},
        r_CM={0.3,0,-0.1}) annotation (extent=[-72,54; -54,76],  rotation=90);
      Modelica.Mechanics.MultiBody.Interfaces.Frame_b to_Aerodynamics 
        annotation (extent=[-16,46; 4,66]);
  equation 
    connect(BodyShape3.frame_b,BodyShape4. frame_a) annotation (points=[60,-48;
            95,-48; 95,-12],      style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape6.frame_a,BodyShape8. frame_a) annotation (points=[-32,6;
            -32,27.3; -18,27.3; -18,27],    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape7.frame_b,BodyShape6. frame_a) annotation (points=[-90,56;
            -80,56; -80,6; -32,6],        style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape1.frame_a,BodyShape6. frame_b) annotation (points=[-32,-28;
            -32,-14],     style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape1.frame_b,LeftPedal. frame_a) annotation (points=[-32,-44;
            -32,-62; -22,-62; -22,-80],                     style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(BodyShape6.frame_a,BodyShape2. frame_a) annotation (points=[-32,6;
            -26.6,6; -26.6,7; -22,7],
                           style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape9.frame_b,BodyShape5. frame_a) annotation (points=[60,-64;
            119,-64; 119,-12],      style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape2.frame_b,BodyShape11. frame_a) annotation (points=[-6,7; -2,
            8; -2,7; 4,7],style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape6.frame_b,BodyShape12. frame_a) annotation (points=[-32,-14;
            -28,-14; -28,-21; -24,-21],    style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(to_Swinging_Arm,BodyShape12. frame_b) annotation (points=[-80,-60;
            -2,-60; -2,-21; -8,-21],
                                  style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(frame_Saddle,BodyShape2. frame_b) annotation (points=[-59,25; -48,
            25; -48,16; -6,16; -6,7],    style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape1.frame_b,BodyShape9. frame_a) annotation (points=[-32,-44;
            -32,-64; 46,-64],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(frame_rear_suspension_up,BodyShape11. frame_a) annotation (points=[-92,-2;
            -72,-2; -72,-6; -42,-6; -42,18; 4,18; 4,7],                style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape10.frame_b,BodyShape15. frame_a) annotation (points=[34,-22;
            34,-28],       style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape15.frame_b,BodyShape3. frame_a) annotation (points=[34,-44;
            34,-48; 46,-48],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(RightPedal.frame_b,BodyShape15. frame_b) annotation (points=[10,-81;
            10,-54; 34,-54; 34,-44],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(frame_Steering,BodyShape14. frame_b) annotation (points=[98,92;
            98,39; 100,39],             style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape14.frame_a,BodyShape5. frame_b) annotation (points=[116,39;
            116,6; 119,6],                             style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape10.frame_a,BodyShape16. frame_a) annotation (points=[34,-2;
            34,15; 42,15],       style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape11.frame_b,BodyShape10. frame_a) annotation (points=[20,7; 34,
            7; 34,-2],              style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape11.frame_b,BodyShape13. frame_b) annotation (points=[20,7; 34,
            7; 34,80; -90,80],              style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape18.frame_b,frame_Steering)  annotation (points=[82,41;
            98,41; 98,92],    style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Mass_Inertia.frame_a,frame_Steering)  annotation (points=[26,56;
            72,56; 72,92; 98,92],    style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Motorcycle_Chassis.frame_a,frame_Steering)  annotation (points=[53,78;
            53,92; 98,92],             style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(frame_Saddle, Pressure_Center.frame_a) annotation (points=[-59,25;
            -59,38.5; -63,38.5; -63,54],   style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Pressure_Center.frame_b, to_Aerodynamics) annotation (points=[-63,76;
            -63,84.55; -6,84.55; -6,56],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
  end Standard_Chassis;
    
  package Data 
    record Base_Chassis_Data 
        
    annotation (
    Documentation(info="<html>
<p> This record contains the data for to define the inertial tensor and the chassis mass. 
</HTML>"));
        
        annotation (
        defaultComponentName="Chassis_data",
        defaultComponentPrefixes="inner",
        Icon);
      parameter Modelica.SIunits.Mass m=75 "Chassis Mass";
      parameter Modelica.SIunits.Inertia I_11=11.085 
          "Chassis Inertia Tensor xx";
      parameter Modelica.SIunits.Inertia I_22=22.013 
          "Chassis Inertia Tensor yy";
      parameter Modelica.SIunits.Inertia I_33=14.982 
          "Chassis Inertia Tensor zz";
      parameter Modelica.SIunits.Inertia I_21=0 "Chassis Inertia Tensor yx";
      parameter Modelica.SIunits.Inertia I_31=-3.691 
          "Chassis Inertia Tensor zx";
      parameter Modelica.SIunits.Inertia I_32=0 "Chassi Inertia Tensor zy";
      parameter Boolean animation=true "Show Animation";
      parameter Modelica.Mechanics.MultiBody.Types.Color color={90,90,90};
    end Base_Chassis_Data;
      
    record Supermotard_Chassis_Data 
        
    annotation (
    Documentation(info="<html>
<p> This record contains the data relative  to a particular type of chassis. 
</HTML>"));
        
      extends Base_Chassis_Data(
        m=75,
        I_11=11.085,
        I_22=22.013,
        I_33=14.982,
        I_21=0,
        I_31=-3.691,
        I_32=0,
        animation=true,
        color={90,90,90});
        annotation (
        defaultComponentName="Chassis_data", Icon);
    end Supermotard_Chassis_Data;
      
    record KTM_950_Chassis_Data 
        
    annotation (
    Documentation(info="<html>
<p> This record contains the data relative  to a particular type of chassis.
</HTML>"));
        
    annotation (
        defaultComponentName="Chassis_data",
        defaultComponentPrefixes="private",
        Icon);
        
      extends Base_Chassis_Data(
        m=179.96,
        I_11=11.085 "Chassis Inertia Tensor xx",
        I_22=22.013 "Chassis Inertia Tensor yy",
        I_33=14.982 "Chassis Inertia Tensor zz",
        I_21=0 "Chassis Inertia Tensor yx",
        I_31=-3.691 "Chassis Inertia Tensor zx",
        I_32=0 "Chassis Inertia Tensor zy",
        animation=true,
        color={90,90,90});
    end KTM_950_Chassis_Data;
  end Data;
    
end Chassis;
  
  package Suspension 
    "This class contains the front spring-damper model, comprehensive of fork and steering gear, and of the back damper" 
    
    annotation (
  Documentation(info="<html>
<p> This package contains the basic model of dampers, front suspension (that contains front fork, handlebar and relative steer stopper), 
    and rear suspension. Both the anterior dampers that those back use the same damper models, composed by a double  
    spring-damper system type one-way. 
 <br>
    The resultant force is egual to the sum of three components but it doesn't consider the torsion that the spring receive.
    The first and second component are calculated in base of two tables, that contains the characteristic of the spring and the damper.
    The last allow to specify the non-linearity and they are defined by function.
<br>
    It is important to underline that the tables output are interpolated, besides it is possible to define the end run value 
    and the inclination of the extreme of the characteristic
</HTML>"));
    
  model Base_Suspension "Nonlinear spring and linear damper in parallel" 
      
  annotation (
  Documentation(info="<html>
<p> Basic model of dampers. 
</HTML>"));
    annotation (Diagram, Icon);
      import Modelica.Mechanics.MultiBody.*;
      import SI = Modelica.SIunits;
    parameter Boolean animation=true "= true, if animation shall be enabled";
    parameter SI.Length s_unstretched=0 "Unstretched spring length";
    parameter SI.Distance width=world.defaultForceWidth 
        "|Animation|if animation = true| Width of spring";
    parameter SI.Distance coilWidth=width/10 
        "|Animation|if animation = true| Width of spring coil";
    parameter Integer numberOfWindings=5 
        "|Animation|if animation = true| Number of spring windings";
    parameter Types.Color color=Modelica.Mechanics.MultiBody.Types.Defaults.
        SpringColor "|Animation|if animation = true| Color of spring";
    parameter Real PreLoad=0;
    parameter Real alpha=1;
    parameter Real beta=1;
    extends Interfaces.PartialLineForce;
    annotation (
      preferedView="info",
      Coordsys(
        extent=[-100, -100; 100, 100],
        grid=[1, 1],
        component=[20, 20]),
      Window(
        x=0.34,
        y=0.26,
        width=0.6,
        height=0.6),
      Documentation(info=""),
  Icon( Text(extent=[-131, -166; 114, -108], string="%name"),
        Line(points=[-80, 40; -60, 40; -45, 10; -15, 70; 15, 10; 45, 70; 60, 40;
               80, 40], style(color=0)),
        Line(points=[-80, 40; -80, -70], style(color=0)),
        Line(points=[-80, -70; -52, -70], style(color=0)),
        Rectangle(extent=[-52, -40; 38, -100], style(color=0, fillColor=8)),
        Line(points=[-52, -40; 68, -40], style(color=0)),
        Line(points=[-52, -100; 68, -100], style(color=0)),
        Line(points=[38, -70; 80, -70], style(color=0)),
        Line(points=[80, 40; 80, -70], style(color=0)),
        Line(points=[-100, 0; -80, 0], style(color=0)),
        Line(points=[80, 0; 100, 0], style(color=0)),
        Text(
          extent=[-140, 72; 138, 108],
          style(color=0),
          string="c,d=%c,%d")),
      Diagram(
        Line(points=[-80, 32; -58, 32; -43, 2; -13, 62; 17, 2; 47, 62; 62, 32;
              80, 32], style(color=0, thickness=2)),
        Line(points=[-68, 32; -68, 97], style(color=10)),
        Line(points=[72, 32; 72, 97], style(color=10)),
        Line(points=[-68, 92; 72, 92], style(color=10)),
        Polygon(points=[62, 95; 72, 92; 62, 89; 62, 95], style(color=10,
              fillColor=10)),
        Text(
          extent=[-20, 72; 20, 97],
          string="s",
          style(color=3)),
        Rectangle(extent=[-52, -20; 38, -80], style(color=0, fillColor=8)),
        Line(points=[-52, -80; 68, -80], style(color=0)),
        Line(points=[-52, -20; 68, -20], style(color=0)),
        Line(points=[38, -50; 80, -50], style(color=0)),
        Line(points=[-80, -50; -52, -50], style(color=0)),
        Line(points=[-80, 32; -80, -50], style(color=0)),
        Line(points=[80, 32; 80, -50], style(color=0)),
        Line(points=[-100, 0; -80, 0], style(color=0)),
        Line(points=[100, 0; 80, 0], style(color=0))));
      
    protected 
    parameter Integer ndim=if world.enableAnimation and animation then 1 else 0;
    Visualizers.Advanced.Shape shape[ndim](
      each shapeType="spring",
      each color=color,
      each length=s,
      each width=width,
      each height=coilWidth*2,
      each lengthDirection=e_a,
      each widthDirection={0,1,0},
      each extra=numberOfWindings,
      each r=frame_a.r_0,
      each R=frame_a.R);
    public 
    Modelica.Blocks.Tables.CombiTable1D Spring_Force(table=Spring) 
      annotation (extent=[-20,40; 0,60]);
    Modelica.Blocks.Tables.CombiTable1D Shock_Absorber(table=Damper) 
      annotation (extent=[-20,10; 0,30]);
    public 
    parameter Real Spring[:,:]=[0,0; 1,1];
    parameter Real Damper[:,:]=[0,0; 1,1];
  equation 
    Spring_Force.u[1]=s_unstretched - s;
    Shock_Absorber.u[1]=der(-s);
    f =-Spring_Force.y[1]*alpha - Shock_Absorber.y[1]*beta - PreLoad;
  end Base_Suspension;
    
  package Front_Suspension 
      
  model Standard_Front_Suspension 
        
  annotation (
  Documentation(info="<html>
<p> Standard type of front suspension 
</HTML>"));
        
    Modelica.Mechanics.MultiBody.Joints.Prismatic Prismatic_Joint(
      initType=Modelica.Mechanics.MultiBody.Types.Init.Position,
      n={0,0,-1},
      animation=false,
          s_start=Front_Suspension_data.Front_s_unstretched) 
      annotation (extent=[-18,-26; 2,22],   rotation=270);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_front_hub 
      annotation (extent=[-8,-100; 12,-80]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_a Front_Joint 
      annotation (extent=[-36, -100; -16, -80]);
    annotation (Diagram, Icon(Bitmap(extent=[-130, 104; 34, -102], name=
                  "images/Front Suspension.gif")));
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_front_suspension 
      annotation (extent=[-112,80; -92,100]);
    Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation1(
      rotationType=Modelica.Mechanics.MultiBody.Types.RotationTypes.
          RotationAxis,
      n={0,-1,0},
          angle=Front_Suspension_data.Caster) 
                     annotation (extent=[-42,72; -22,92]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_a Steering 
      annotation (extent=[-80,80; -60,100]);
    Real Caster=Front_Suspension_data.Caster "Caster Angle [deg]";
    Modelica.SIunits.Inertia I_11=Front_Suspension_data.I_11 
          "Inertia Tensor xx";
    Modelica.SIunits.Inertia I_22=Front_Suspension_data.I_22 
          "Inertia Tensor yy";
    Modelica.SIunits.Inertia I_33=Front_Suspension_data.I_33 
          "Inertia Tensor zz";
    Modelica.SIunits.Inertia I_21=Front_Suspension_data.I_21 
          "Inertia Tensor yx";
    Modelica.SIunits.Inertia I_31=Front_Suspension_data.I_31 
          "Inertia Tensor zx";
    Modelica.SIunits.Inertia I_32=Front_Suspension_data.I_32 
          "Inertia Tensor zy";
    Modelica.SIunits.Mass Steering_M=Front_Suspension_data.Steering_M 
          "Steering_Mass";
    Modelica.SIunits.Mass Suspension_M=Front_Suspension_data.Suspension_M 
          "Fork Mass";
    Boolean animation=Front_Suspension_data.animation "Show Animation";
    Real Spring[:,:]=Front_Suspension_data.Spring;
    Real Damper[:,:]=Front_Suspension_data.Damper;
    Modelica.SIunits.Length Front_s_unstretched=Front_Suspension_data.Front_s_unstretched;
    Modelica.Mechanics.MultiBody.Types.Color color=Front_Suspension_data.color;
    parameter Modelica.SIunits.Position Fork_r_CM[3]={0.294,0,-0.438} 
          "{C_dx,0,-C_dy}";
        
    parameter Modelica.SIunits.Position Steering_r_CM[3]={0.034,0,0.097} 
          "{D_dx,0,D_dy}";
    Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape1(
          animation=Front_Suspension_data.animation,
          shapeType="cylinder",
          lengthDirection={0,0,1},
          width=0.05,
          height=0.05,
          color={80,80,80},
          length=Front_Suspension_data.Front_s_unstretched*0.6) 
                            annotation (extent=[-82,-34; -62,-14], rotation=90);
    Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation2(
      rotationType=Modelica.Mechanics.MultiBody.Types.RotationTypes.
          RotationAxis,
      n={0,-1,0},
          angle=-Front_Suspension_data.Caster) 
                     annotation (extent=[40,80; 60,100]);
    Base_Suspension Nonlinear_Spring_Damper1(
      animation=false,
          s_unstretched=Front_Suspension_data.Front_s_unstretched,
          Spring=Front_Suspension_data.Spring,
          Damper=Front_Suspension_data.Damper,
          alpha=1,
          beta=1,
          PreLoad=752) 
                 annotation (extent=[-44,-14; -24,6], rotation=270);
    Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape2(
      animation=Front_Suspension_data.animation,
      shapeType="cylinder",
      lengthDirection={0,0,1},
      width=0.05,
      height=0.05,
      color={80,80,80},
          length=Front_Suspension_data.Front_s_unstretched*0.6) 
      annotation (extent=[32,-32; 52,-12], rotation=90);
    Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape3(
      shapeType="cylinder",
      color={180,180,180},
      lengthDirection={0,0,1},
      width=0.06,
      height=0.06,
          animation=Front_Suspension_data.animation,
          length=-Front_Suspension_data.Front_s_unstretched*0.7) 
      annotation (extent=[-82,0; -62,20], rotation=270);
    Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape4(
      shapeType="cylinder",
      color={180,180,180},
      lengthDirection={0,0,1},
      width=0.06,
      height=0.06,
          animation=Front_Suspension_data.animation,
          length=-Front_Suspension_data.Front_s_unstretched*0.7) 
      annotation (extent=[34,-4; 54,16], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Steering_Mass_Inertia(
          cylinderDiameter=0,
          sphereDiameter=0.08,
          sphereColor={150,150,20},
          animation=Front_Suspension_data.animation,
          m=Front_Suspension_data.Steering_M,
          I_11=Front_Suspension_data.I_11,
          I_22=Front_Suspension_data.I_22,
          I_33=Front_Suspension_data.I_33,
          I_21=Front_Suspension_data.I_21,
          I_31=Front_Suspension_data.I_31,
          I_32=Front_Suspension_data.I_32,
          r_CM=Steering_r_CM) 
                 annotation (extent=[70,56; 90,76], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Suspension_Mass(
          cylinderDiameter=0,
          sphereDiameter=0.08,
          sphereColor={150,150,20},
          animation=Front_Suspension_data.animation,
          m=Front_Suspension_data.Suspension_M,
          r_CM=Fork_r_CM) 
                      annotation (extent=[102,56; 122,76], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape1(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0.09,0.12,0},
      width=0.045,
          color={20,20,20},
          animation=Front_Suspension_data.animation) 
                   annotation (extent=[-160,46; -140,66]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape2(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0.025,0.1,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[-134,46; -114,66]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape3(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0,0,-0.09},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[-108,46; -88,66]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape4(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={-0.05,0.02,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[-68,42; -48,62], rotation=90);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape5(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0,0.12,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[-36,28; -16,48], rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape6(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0,0.12,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[0,28; 20,48], rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape7(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0,0.12,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[-58,-52; -38,-32], rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape8(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0,0.12,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[4,-52; 24,-32], rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape9(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0,0.1,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[-38,52; -18,72], rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape10(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0,0.1,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[-2,52; 18,72], rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape11(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0,0,0.09},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[60,26; 80,46]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape12(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={-0.025,0.1,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[88,26; 108,46]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape13(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={-0.09,0.12,0},
      width=0.045,
          color={20,20,20},
          animation=Front_Suspension_data.animation) 
                   annotation (extent=[116,26; 136,46]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape14(
      animateSphere=false,
      m=0,
      I_11=0,
      I_22=0,
      I_33=0,
      I_21=0,
      I_31=0,
      I_32=0,
      r={0.05,0.02,0},
      width=0.045,
          animation=Front_Suspension_data.animation,
          color=Front_Suspension_data.color) 
                   annotation (extent=[30,38; 50,58], rotation=270);
        Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape5(
          shapeType="box",
          color={100,100,100},
          lengthDirection={0,0,-1},
          length=0.2,
          width=0.25,
          r_shape={0.03,0,-0.06},
          height=0.01,
          animation=Front_Suspension_data.animation) 
                       annotation (extent=[-132,-24; -112,-4], rotation=270);
        Modelica.Mechanics.MultiBody.Joints.ActuatedRevolute Front_J(animation=
              Front_Suspension_data.animation, n={0,1,0}) 
          annotation (extent=[-20,-76; 0,-56], rotation=90);
        Modelica.Mechanics.MultiBody.Joints.ActuatedRevolute Steer_Joint(
            animation=Front_Suspension_data.animation,
          planarCutJoint=false,
          initType=Modelica.Mechanics.MultiBody.Types.Init.Position) 
          annotation (extent=[2,82; 22,98]);
      public 
    parameter Data.Base_Front_Suspension_Data Front_Suspension_data 
      annotation (extent=[-100,-100; -80,-80],
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial);
      public 
        Steer_Stopper Steer_Stopper1(Limit_Angle=Front_Suspension_data.
              Steer_Stopper) annotation (extent=[-22,94; -2,114]);
        Modelica.Mechanics.Rotational.Brake Brake1(cgeo=4*(0.16 + 0.12)/2, fn_max=
              4000)       annotation (extent=[-74,-94; -54,-74], rotation=0);
        Modelica.Blocks.Interfaces.RealInput Front_Brake 
          annotation (extent=[-100,-70; -80,-50]);
  equation 
        connect(FixedRotation2.frame_b, Steering_Mass_Inertia.frame_a) 
                                                           annotation (points=[60,90;
              80,90; 80,76],    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(FixedRotation2.frame_b, Suspension_Mass.frame_a) annotation (points=[60,90;
              112,90; 112,76],    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_front_suspension, FixedRotation1.frame_a) annotation (points=[-102,90;
              -86,90; -86,102; -50,102; -50,82; -42,82],       style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape1.frame_b, BodyShape2.frame_a) annotation (points=[-140,56;
              -134,56],
                    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape2.frame_b, BodyShape3.frame_a) annotation (points=[-114,56;
              -108,56],
                    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape3.frame_b, BodyShape4.frame_b) annotation (points=[-88,56;
              -76,56; -76,68; -58,68; -58,62],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(FixedShape3.frame_a, BodyShape4.frame_a) annotation (points=[-72,20;
              -72,32; -58,32; -58,42],
                                   style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape5.frame_b, Prismatic_Joint.frame_a) annotation (points=[-16,38;
              -8,38; -8,22],       style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Prismatic_Joint.frame_a, BodyShape6.frame_a) annotation (points=[-8,22;
              -8,38; 0,38],    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape4.frame_a, BodyShape5.frame_a) annotation (points=[-58,42;
              -58,38; -36,38],
                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape7.frame_b, Prismatic_Joint.frame_b) annotation (points=[-38,-42;
              -8,-42; -8,-26],        style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Prismatic_Joint.frame_b, BodyShape8.frame_a) annotation (points=[-8,-26;
              -8,-42; 4,-42],    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape8.frame_b, FixedShape2.frame_a) annotation (points=[24,-42;
              42,-42; 42,-32],
                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape4.frame_b, BodyShape9.frame_a) annotation (points=[-58,62;
              -58,68; -44,68; -44,62; -38,62],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape9.frame_b, BodyShape10.frame_a) annotation (points=[-18,62;
              -2,62],
                  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape11.frame_b, BodyShape12.frame_a) annotation (points=[80,36;
              88,36],
                  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape12.frame_b, BodyShape13.frame_a) annotation (points=[108,36;
              116,36], style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Nonlinear_Spring_Damper1.frame_a, Prismatic_Joint.frame_a) 
      annotation (points=[-34,6; -34,22; -8,22],     style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(Nonlinear_Spring_Damper1.frame_b, Prismatic_Joint.frame_b) 
      annotation (points=[-34,-14; -34,-26; -8,-26],     style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape14.frame_b, FixedShape4.frame_a) annotation (points=[40,38;
              40,22; 44,22; 44,16],
                                style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape10.frame_b, BodyShape14.frame_a) annotation (points=[18,62;
              26,62; 26,72; 40,72; 40,58],
                                       style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape14.frame_a, BodyShape11.frame_a) annotation (points=[40,58;
              40,72; 54,72; 54,36; 60,36],
                                       style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
        connect(FixedShape5.frame_a, Prismatic_Joint.frame_a) annotation (
            points=[-122,-4; -122,24; -60,24; -60,22; -8,22],     style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2));
        connect(Prismatic_Joint.frame_b, Front_J.frame_b) annotation (points=[-8,-26;
              -8,-56; -10,-56],                                          style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2));
        connect(Front_J.frame_a, frame_front_hub) annotation (points=[-10,-76;
              6,-76; 6,-90; 2,-90],         style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2));
        connect(Front_Joint, Front_J.axis) annotation (points=[-26,-90; -26,-66;
              -20,-66], style(color=0, rgbcolor={0,0,0}));
        connect(Steer_Joint.frame_b, FixedRotation2.frame_a) annotation (points=[22,90;
              40,90],        style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2));
        connect(Steer_Joint.frame_b, BodyShape9.frame_b) annotation (points=[22,90;
              30,90; 30,76; -12,76; -12,62; -18,62],     style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2));
        connect(Steer_Joint.frame_a, FixedRotation1.frame_b) annotation (points=[2,90;
              -10,90; -10,82; -22,82],       style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2));
        connect(Steering, Steer_Joint.axis) annotation (points=[-70,90; -70,98;
          12,98],             style(color=0, rgbcolor={0,0,0}));
        connect(FixedShape1.frame_a, BodyShape7.frame_a) annotation (points=[-72,-34;
              -72,-42; -58,-42],          style(
            color=0,
            rgbcolor={0,0,0},
            thickness=2));
        connect(Steer_Stopper1.steer, Steer_Joint.axis) annotation (points=[-3.4,105;
              12,105; 12,98],           style(color=0, rgbcolor={0,0,0}));
        connect(Brake1.f_normalized, Front_Brake) annotation (points=[-64,-73;
              -64,-60; -90,-60], style(color=74, rgbcolor={0,0,127}));
        connect(Brake1.flange_b, Front_J.axis) annotation (points=[-54,-84; -46,
              -84; -46,-66; -20,-66], style(color=0, rgbcolor={0,0,0}));
  end Standard_Front_Suspension;
      
    model Steer_Stopper 
        
    annotation (
    Documentation(info="<html>
<p> This component's operation is associated to a table. This component provide a void couple on steering gear when the angle of
steering gear is in the normal functioning zone and a high couple when the steering gear is near the steer stopper, assuring that the
steering gear doesn't increase over the ceiling.
</HTML>"));
        
        import Modelica.Math.*;
        
      parameter Real Limit_Angle = 0.3 "Value of limit steer angle [deg]";
      Modelica.Mechanics.Rotational.Interfaces.Flange_b steer 
        annotation (extent=[76,0; 96,20]);
      annotation (Diagram);
      public 
      Modelica.Blocks.Tables.CombiTable1D Torque(table=[-31,-10000; -30,0; 30,0;
              31,10000], smoothness=Modelica.Blocks.Types.Smoothness.
              LinearSegments) 
        annotation (extent=[-20,0; 0,20]);
    algorithm 
    //equation 
    //steer.tau=tan(steer.phi*90/Limit_Angle)*2;
    Torque.u[1]:=steer.phi*180/Modelica.Constants.pi;
    steer.tau:=Torque.y[1];
    end Steer_Stopper;
      
    package Data 
        
      record Base_Front_Suspension_Data 
          
      annotation (
      Documentation(info="<html>
<p> This record contains the data for to define the inertial tensor, the front fork mass, the steering gear and the spring-damper characteristic
of front suspension. 
</HTML>"));
          
        annotation (
          defaultComponentName="Front_Suspension_data",
          defaultComponentPrefixes="inner");
        parameter Real Caster=27.8 "Caster Angle [deg]";
        parameter Modelica.SIunits.Inertia I_11=1.341 "Inertia Tensor xx";
        parameter Modelica.SIunits.Inertia I_22=1.584 "Inertia Tensor yy";
        parameter Modelica.SIunits.Inertia I_33=0.4125 "Inertia Tensor zz";
        parameter Modelica.SIunits.Inertia I_21=0 "Inertia Tensor yx";
        parameter Modelica.SIunits.Inertia I_31=0 "Inertia Tensor zx";
        parameter Modelica.SIunits.Inertia I_32=0 "Inertia Tensor zy";
        parameter Modelica.SIunits.Mass Steering_M=9.99 "Steering_Mass";
        parameter Modelica.SIunits.Mass Suspension_M=7.25 "Fork Mass";
        parameter Boolean animation=true "Show Animation";
        parameter Real Spring[:,:]=[-0.1, -1000000;-0.08, -450; -0.06, -215.934; -0.05, 450.691; 0, 850.666; 0.048, 1234.642; 0.054, 1330.636; 0.06, 1959.3967; 0.08, 2800; 0.1, 1000000];
        parameter Real Damper[:,:]=[-1.41, -2237.975; -0.72, -1535.48; -0.39, -1038.549; -0.21, -800.809; -0.09, -450.455; -0.02, -101.889; 0.02, 101.889; 0.09, 266.341; 0.2, 350.354; 0.39, 491.568; 0.76, 802.597; 1.16, 1144.013];
        parameter Modelica.SIunits.Length Front_s_unstretched=0.88;
        parameter Modelica.Mechanics.MultiBody.Types.Color color={90,90,90};
        parameter Real Steer_Stopper = 20 
            "Maximum angle value for steer [joint deg]";
      end Base_Front_Suspension_Data;
        
      record Supermotard_Front_Suspension_Data 
          
      annotation (
      Documentation(info="<html>
<p> This record contains the data relative  to a particular type of front suspension. 
</HTML>"));
          
          extends Base_Front_Suspension_Data(
          Caster=27.8,
          I_11=1.341,
          I_22=1.584,
          I_33=0.4125,
          I_21=0,
          I_31=0,
          I_32=0,
          Steering_M=9.99,
          Suspension_M=7.25,
          animation=true,
          Spring=[-0.1, -1000000;-0.08, -450; -0.06, -215.934; -0.05, 450.691; 0, 850.666; 0.048, 1234.642; 0.054, 1330.636; 0.06, 1959.3967; 0.08, 2800; 0.1, 1000000],
          Damper=[-1.41, -2237.975; -0.72, -1535.48; -0.39, -1038.549; -0.21, -800.809; -0.09, -450.455; -0.02, -101.889; 0.02, 101.889; 0.09, 266.341; 0.2, 350.354; 0.39, 491.568; 0.76, 802.597; 1.16, 1144.013],
          Front_s_unstretched=0.88,
          color={90,90,90},
          Steer_Stopper = 20);
        annotation (
          defaultComponentName="Front_Suspension_data");
      end Supermotard_Front_Suspension_Data;
        
      record KTM_950_Front_Suspension_data 
          
      annotation (
      Documentation(info="<html>
<p> This record contains the data relative  to a particular type of front suspension. 
</HTML>"));
          
      annotation (
          defaultComponentName="Front_Suspension_data",
          defaultComponentPrefixes="private",
          Icon);
        extends Base_Front_Suspension_Data(
        Caster=27.8,
          I_11=1.341,
          I_22=1.584,
          I_33=0.4125,
          I_21=0,
          I_31=0,
          I_32=0,
          Steering_M=9.99,
          Suspension_M=9.67,
          animation=true,
          Spring=[-0.206,-6497.2;-0.2059,-6496.3;-0.20345,-6231.0;-0.20065,-5663.3;-0.19805,-5240.8;-0.19568,-4885.9;-0.19210,-4508.1;-0.18962,-4270.4;-0.18279,-3712.1;-0.17582,-3305.3;-0.17088,-3084.4;-0.16096,-2726.6;-0.15125,-2443.5;-0.13904,-2151.3;-0.12920,-1951.2;-0.11948,-1773.6;-0.10974,-1608.3;-0.10053,-1461.6;-0.09068,-1315.3;-0.08112,-1180.3;-0.07108,-1047.4;-0.06144,-920.8;-0.04922,-767.4;-0.03955,-646.2;-0.02964,-530.6;-0.02045,-420.5;-0.01084,-309.5;0.00,182.4;0.01084,309.5;0.02045,420.5;0.02964,530.6;0.03955,646.2;0.04922,767.4;0.06144,920.8;0.07108,1047.4;0.08112,1180.3;0.09068,1315.3;0.10053,1461.6;0.10974,1608.3;0.11948,1773.6;0.12920,1951.2;0.13904,2151.3;0.15125,2443.5;0.16096,2726.6;0.17088,3084.4;0.17582,3305.3;0.18279,3712.1;0.18962,4270.4;0.19210,4508.1;0.19568,4885.9;0.19805,5240.8;0.20065,5663.3;0.20345,6231.0;0.20590,6496.3;0.2060,6497.2],
          Damper=[-4,-2200.0;-1.950,-1215.0;-1.4850,-950.0;-1.2500,-815.0;-1.0000,-690.0;-0.7550,-557.0;-0.5050,-403.0;-0.2000,-164.0;-0.1000,-77.0;-0.0500,-48.0;-0.0100,-31.0;0.0,0.0;0.0100,36.0;0.0500,52.0;0.1000,54.0;0.2000,59.0;0.5000,75.0;0.7500,90.0;1.0000,103.0;1.2500,139.0;1.5000,135.0;1.7200,152.0;1.9500,166.0;4.0000,300.0],
          Front_s_unstretched=0.88,
          color={90,90,90},
          Steer_Stopper = 20);
          
      end KTM_950_Front_Suspension_data;
    end Data;
  end Front_Suspension;
    
  package Rear_Suspension 
      
  model Standard_Rear_Suspension 
  annotation (
  Documentation(info="<html>
<p> Standard type of rear suspension 
</HTML>"));
        
    annotation (Diagram, Icon(Bitmap(extent=[-102, 94; 88, -96], name=
                  "images/Rear Suspension.gif")));
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_up 
                                          annotation (extent=[16, 76; 36, 96]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_down 
      annotation (extent=[-58, -94; -38, -74]);
    Base_Suspension Nonlinear_Spring_Damper1(
          width=0.08,
          coilWidth=0.01,
          numberOfWindings=6,
          color={255,0,0},
          s_unstretched=Rear_Suspension_data.s_unstretched,
          Spring=Rear_Suspension_data.Spring,
          Damper=Rear_Suspension_data.Damper,
          alpha=1,
          beta=1,
          PreLoad=3600,
          animation=Rear_Suspension_data.animation) 
      annotation (extent=[-58,-40; 14,24], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape1(
                                         m=0, r=Seaddle_to_Rear_Suspension_Up) 
      annotation (extent=[-32,44; -12,64], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape2(
                                         m=0, r=M) 
      annotation (extent=[-32,-78; -12,-58], rotation=90);
      public 
    parameter Data.Base_Rear_Suspension_Data Rear_Suspension_data 
      annotation (extent=[80,-40; 100,-20],
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial,
          DymolaEmptyOuterSpecial);
      public 
    Modelica.SIunits.Length s_unstretched=Rear_Suspension_data.s_unstretched;
    Boolean animation=Rear_Suspension_data.animation "Show Animation";
    Real Spring[:,:]=Rear_Suspension_data.Spring;
    Real Damper[:,:]=Rear_Suspension_data.Damper;
        
    parameter Modelica.SIunits.Position Seaddle_to_Rear_Suspension_Up[3]={0.071,0,
        -0.109} "From Seaddle to Rear Suspension (upper frame) {H_dx,0,-H_dy}";
        parameter Modelica.SIunits.Position M[3]={-0.105,0,0.013} 
          "From rear swinging arm joint to rear suspension lower attachment {-M_dx,0,M_dy}";
  equation 
    connect(Nonlinear_Spring_Damper1.frame_a, BodyShape1.frame_b) annotation (
        points=[-22,24; -22,30.9; -22,30.9; -22,34.6; -22,44; -22,44],
        style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape1.frame_a, frame_up) annotation (points=[-22,64; -22,86;
              26,86],
                  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape2.frame_b, Nonlinear_Spring_Damper1.frame_b) annotation (
        points=[-22,-58; -22,-58; -22,-40; -22,-40],       style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_down, BodyShape2.frame_a) annotation (points=[-48,-84; -22,
              -84; -22,-78],
                         style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
  end Standard_Rear_Suspension;
      
    package Data 
      record Base_Rear_Suspension_Data 
          
      annotation (
      Documentation(info="<html>
<p> This record contains the data for the spring-damper of rear suspension.
</HTML>"));
          
        annotation (
          defaultComponentName="Rear_Suspension_data",
          defaultComponentPrefixes="inner");
        parameter Modelica.SIunits.Length s_unstretched=0.255;
        parameter Boolean animation=true "Show Animation";
        parameter Real Spring[:,:]=[-0.351, -1000000; -0.35, -62580.77; -0.3, -25928.77; 0, -4059.23; 0.29, 330470.63; 0.32, 454920.65; 0.35, 100204.09; 0.351, 1000000];
        parameter Real Damper[:,:]=[-1.41, -41961.922584; -0.72, -28790.173226; -0.39, -19472.73859; -0.21, -15015.125477; -0.09, -8446.01196; -0.02, -1910.410423; 0.02, 1910.410423; 0.09, 4493.8772; 0.2, 6569.113517; 0.39, 9216.875442; 0.76, 15048.630387; 1.16, 21450.183317];
      end Base_Rear_Suspension_Data;
        
      record Supermotard_Rear_Suspension_Data 
          
      annotation (
      Documentation(info="<html>
<p> This record contains the data relative  to a particular type of rear suspension. 
</HTML>"));
          
        extends Base_Rear_Suspension_Data(
          s_unstretched=0.255,
          animation=true,
          Spring=[-0.351, -1000000; -0.35, -62580.77; -0.3, -25928.77; 0, -4059.23; 0.29, 330470.63; 0.32, 454920.65; 0.35, 100204.09; 0.351, 1000000],
          Damper=[-1.41, -41961.922584; -0.72, -28790.173226; -0.39, -19472.73859; -0.21, -15015.125477; -0.09, -8446.01196; -0.02, -1910.410423; 0.02, 1910.410423; 0.09, 4493.8772; 0.2, 6569.113517; 0.39, 9216.875442; 0.76, 15048.630387; 1.16, 21450.183317]);
        annotation (
          defaultComponentName="Rear_Suspension_data");
      end Supermotard_Rear_Suspension_Data;
        
      record KTM_950_Rear_Suspension_Data 
          
      annotation (
      Documentation(info="<html>
<p> This record contains the data relative  to a particular type of rear suspension. 
</HTML>"));
          
      annotation (
          defaultComponentName="Rear_Suspension_data",
          defaultComponentPrefixes="private",
          Icon);
        extends Base_Rear_Suspension_Data(
       s_unstretched=0.255,
          animation=true,
          Spring=[-0.0746, -22640; -0.070, -15950; -0.069, -15470; -0.0675, -14655; -0.065, -13740; -0.060, -12300; -0.050, -9900; -0.0465, -9025; -0.040, -8050; -0.030, -6550; -0.020, -5050; -0.010, -3550; 0, 2050; 0.010, 3550; 0.020, 5050; 0.030, 6550; 0.040, 8050; 0.0465, 9025; 0.050, 9900; 0.060, 12300; 0.065, 13740; 0.0675, 14655; 0.069, 15470; 0.070, 15950; 0.0746, 22640],
          Damper=[-4.0000,-22500;-1.4280,-9694;-1.2140,-8558;-0.9820,-7294;-0.7420,-5936;-0.5000,-4520;-0.2500,-2745;-0.1000,-1532;-0.0500,-1020;-0.0097,-150;0,0;0.0100,105;0.0503,408;0.1000,690;0.2500,1628;0.5000,2637;0.7430,3516;0.9820,4354;1.2120,5110;1.4400,5860;4.0000,15000]);
          
      end KTM_950_Rear_Suspension_Data;
    end Data;
  end Rear_Suspension;
    
  end Suspension;
  
  package Rear_Swinging_Arm 
    "This class contains the rear swing arm and this is all customable" 
    
  model Rear_Swinging_Arm 
  /*
  Modelica.SIunits.Mass m=Rear_Swinging_Arm_data.m "Mass";
  Modelica.SIunits.Inertia I_11=Rear_Swinging_Arm_data.I_11 "Inertia Tensor xx";
  Modelica.SIunits.Inertia I_22=Rear_Swinging_Arm_data.I_22 "Inertia Tensor yy";
  Modelica.SIunits.Inertia I_33=Rear_Swinging_Arm_data.I_33 "Inertia Tensor zz";
  Modelica.SIunits.Inertia I_21=Rear_Swinging_Arm_data.I_21 "Inertia Tensor yx";
  Modelica.SIunits.Inertia I_31=Rear_Swinging_Arm_data.I_31 "Inertia Tensor zx";
  Modelica.SIunits.Inertia I_32=Rear_Swinging_Arm_data.I_32 "Inertia Tensor zy";
  Boolean animation=Rear_Swinging_Arm_data.animation "Show Animation";
  Modelica.Mechanics.MultiBody.Types.Color color=Rear_Swinging_Arm_data.color;
*/
    parameter Modelica.SIunits.Position xyz_init[3]={0,0,0.3} 
        "Rear Wheel Initial Position";
  /*
  parameter Modelica.SIunits.Position Swinging_Arm[3]={0.503,0,0.134} 
    "Rear Swinging Arm {N_dx,0,N_dy}";
  parameter Modelica.SIunits.Position Rear_Swinging_Arm_Mass[3]={0.42,0,
        0.08} 
    "Rear Swinging Arm Mass Position from Rear Wheel Hub {O_dx,0,O_dy}";
*/
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_rear_suspension_down 
      annotation (extent=[-2, 16; 42, 36]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_a Rear_Joint 
      annotation (extent=[-152, -36; -124, -16]);
    Modelica.Mechanics.MultiBody.Joints.ActuatedRevolute Rear_J(
      n={0,1,0},
        animation=Rear_Swinging_Arm_data.animation) 
                      annotation (extent=[-22, -62; -10, -50], rotation=90);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape1(
      width=0.045,
      animateSphere=false,
      m=0,
        animation=Rear_Swinging_Arm_data.animation,
        color=Rear_Swinging_Arm_data.color,
        r={Dimension_MassPosition_data.N_dx,0,Dimension_MassPosition_data.N_dy}) 
                           annotation (extent=[19,-14; 33,-2]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_rear_hub 
      annotation (extent=[-132, -36; -100, -16]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a to_Chassis 
      annotation (extent=[88, 34; 128, 54]);
    Modelica.Mechanics.MultiBody.Joints.Revolute Revolute1(
                                        n={0,1,0},
        initType=Modelica.Mechanics.MultiBody.Types.Init.Position,
        phi_start=0,
        animation=Rear_Swinging_Arm_data.animation) 
      annotation (extent=[80, 46; 94, 58]);
    Modelica.Mechanics.MultiBody.Parts.Body Mass_Inertia(
        cylinderDiameter=0,
        sphereDiameter=0.08,
        sphereColor={150,150,20},
        animation=Rear_Swinging_Arm_data.animation,
        m=Rear_Swinging_Arm_data.m,
        I_11=Rear_Swinging_Arm_data.I_11,
        I_22=Rear_Swinging_Arm_data.I_22,
        I_33=Rear_Swinging_Arm_data.I_33,
        I_21=Rear_Swinging_Arm_data.I_21,
        I_31=Rear_Swinging_Arm_data.I_31,
        I_32=Rear_Swinging_Arm_data.I_32,
        r_CM={Dimension_MassPosition_data.O_dx,0,Dimension_MassPosition_data.
            O_dy},
        initType=Modelica.Mechanics.MultiBody.Types.Init.Position,
        r_0_start=xyz_init) 
                           annotation (extent=[-70, 6; -50, 26], rotation=180);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape17(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0,0.1,0},
        animation=Rear_Swinging_Arm_data.animation,
        color=Rear_Swinging_Arm_data.color) 
                           annotation (extent=[62,-48; 74,-36], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape2(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0,0.1,0},
        animation=Rear_Swinging_Arm_data.animation,
        color=Rear_Swinging_Arm_data.color) 
                           annotation (extent=[62,-14; 74,-2], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape3(
      width=0.045,
      animateSphere=false,
      m=0,
      r={0.503,0,0.134},
        animation=Rear_Swinging_Arm_data.animation,
        color=Rear_Swinging_Arm_data.color) 
                           annotation (extent=[29,-72; 43,-60]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape4(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0,0.1,0},
        animation=Rear_Swinging_Arm_data.animation,
        color=Rear_Swinging_Arm_data.color) 
                           annotation (extent=[-12,-22; 0,-10], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape5(
      width=0.045,
      m=0,
      animateSphere=false,
        r={0,0.1,0},
        animation=Rear_Swinging_Arm_data.animation,
        color=Rear_Swinging_Arm_data.color) 
                           annotation (extent=[-4,-62; 8,-50], rotation=270);
    annotation (Diagram, Icon(Bitmap(extent=[-146, 104; 120, -48], name=
                "images/Swinging Arm.gif")));
    public 
    parameter Data.Base_Swinging_Arm_Data Rear_Swinging_Arm_data 
      annotation (extent=[-100,80; -80,100],
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial);
    public 
      parameter Base_Dimension_MassPosition_Data Dimension_MassPosition_data 
        annotation (extent=[-80,80; -60,100],
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial);
    public 
      Modelica.Mechanics.Rotational.Brake Brake1(cgeo=2*(0.11 + 0.07)/2, fn_max=
            3000) annotation (extent=[-46,-46; -26,-26], rotation=0);
      Modelica.Blocks.Interfaces.RealInput Rear_Brake 
        annotation (extent=[-90,-36; -70,-16]);
  equation 
    connect(Rear_J.axis, Rear_Joint) annotation (points=[-22, -56; -138, -56; -138,
          -26], style(color=0, rgbcolor={0,0,0}));
    connect(Revolute1.frame_b, to_Chassis) annotation (points=[94,52; 101.35,52;
            101.35,44; 108,44],     style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_rear_hub, Rear_J.frame_a) annotation (points=[-116,-26; -70,
            -26; -70,-66; -16,-66; -16,-62],    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Mass_Inertia.frame_a, Rear_J.frame_b) 
                                             annotation (points=[-50,16; -16,16;
            -16,-50],               style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_rear_suspension_down, Revolute1.frame_a) annotation (points=[20,26;
            40,26; 40,28; 60,28; 60,52; 80,52],        style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(BodyShape1.frame_b, BodyShape2.frame_a) annotation (points=[33,-8;
            50,-8; 50,-2; 68,-2],         style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape3.frame_b, BodyShape17.frame_b) annotation (points=[43,-66;
            68,-66; 68,-48],        style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape2.frame_b, Revolute1.frame_a) annotation (points=[68,-14;
            68,-20; 80,-20; 80,12; 66,12; 66,52; 80,52],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape4.frame_a, BodyShape1.frame_a) annotation (points=[-6,-10;
            8,-10; 8,-8; 19,-8],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape4.frame_b, Rear_J.frame_b) annotation (points=[-6,-22;
            -6,-42; -16,-42; -16,-50],   style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Rear_J.frame_b, BodyShape5.frame_a) annotation (points=[-16,-50;
            -11.5,-50; -11.5,-50.6; -7,-50.6; -7,-50; 2,-50],
                      style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(BodyShape5.frame_b, BodyShape3.frame_a) annotation (points=[2,-62; 2,
            -66; 29,-66],            style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Brake1.flange_b, Rear_J.axis) annotation (points=[-26,-36; -26,
            -52; -22,-52; -22,-56], style(color=0, rgbcolor={0,0,0}));
      connect(Brake1.f_normalized, Rear_Brake) annotation (points=[-36,-25; -36,
            -26; -80,-26], style(color=74, rgbcolor={0,0,127}));
  end Rear_Swinging_Arm;
    
    package Data 
      record Base_Swinging_Arm_Data 
        
      annotation (
      Documentation(info="<html>
<p> This record contains the data for the dimension of the rear swing arm.
</HTML>"));
        
        annotation (
          defaultComponentName="Rear_Swinging_Arm_data",
          defaultComponentPrefixes="inner");
        parameter Modelica.SIunits.Mass m=12 "Mass";
        parameter Modelica.SIunits.Inertia I_11=0.03 "Inertia Tensor xx";
        parameter Modelica.SIunits.Inertia I_22=0.415 "Inertia Tensor yy";
        parameter Modelica.SIunits.Inertia I_33=0.415 "Inertia Tensor zz";
        parameter Modelica.SIunits.Inertia I_21=0 "Inertia Tensor yx";
        parameter Modelica.SIunits.Inertia I_31=0 "Inertia Tensor zx";
        parameter Modelica.SIunits.Inertia I_32=0 "Inertia Tensor zy";
        parameter Boolean animation=true "Show Animation";
        parameter Modelica.Mechanics.MultiBody.Types.Color color={90,90,90};
      end Base_Swinging_Arm_Data;
      
      record Supermotard_Rear_Swinging_Arm_Data 
        
      annotation (
      Documentation(info="<html>
<p> This record contains the data for the dimension of the particular rear swing arm.
</HTML>"));
        
        extends Base_Swinging_Arm_Data(
          m=8,
          I_11=0.03,
          I_22=0.415,
          I_33=0.415,
          I_21=0,
          I_31=0,
          I_32=0,
          animation=true,
          color={90,90,90});
        annotation (
          defaultComponentName="Rear_Swinging_Arm_data",
          defaultComponentPrefixes="inner");
      end Supermotard_Rear_Swinging_Arm_Data;
      
      record KTM_950_Rear_Swingin_Arm_Data 
        
      annotation (
      Documentation(info="<html>
<p> This record contains the data for the dimension of the particular rear swing arm.
</HTML>"));
        
      annotation (
          defaultComponentName="Rear_Swinging_Arm_data",
          defaultComponentPrefixes="private");
        extends Base_Swinging_Arm_Data(
          m=11.15,
          I_11=0.02,
          I_22=0.259,
          I_33=0.259,
          I_21=0,
          I_31=0,
          I_32=0,
          animation=true,
          color={90,90,90});
       annotation (
          defaultComponentName="Rear_Swinging_Arm_data",
          defaultComponentPrefixes="inner");
        
      end KTM_950_Rear_Swingin_Arm_Data;
    end Data;
  end Rear_Swinging_Arm;
  
  package Wheel 
    "This class contains all component, parameters, dimensions, inertie and the wheel friction model." 
    
  annotation (
  Documentation(info="<html>
<p> This class contain all component that concern to wheel and tires.
</HTML>"));
    
  model Standard_Wheel "Standard type of wheel" 
    Real Kel=Wheel_data.Kel "Pneumatic Elastic Constant";
    Real Del=Wheel_data.Del "Pneumatic Dumping Constant";
    Modelica.SIunits.Inertia I_11=Wheel_data.I_11 "Inertia tensor xx";
    Modelica.SIunits.Inertia I_22=Wheel_data.I_22 "Inertia tensor yy";
    Modelica.SIunits.Inertia I_33=Wheel_data.I_33 "Inertia tensor zz";
    Modelica.SIunits.Inertia I_21=Wheel_data.I_21 "Inertia tensor yx";
    Modelica.SIunits.Inertia I_31=Wheel_data.I_31 "Inertia tensor zx";
    Modelica.SIunits.Inertia I_32=Wheel_data.I_32 "Inertia tensor zy";
    Modelica.SIunits.Mass m=Wheel_data.m "Wheel mass";
    Boolean animation=Wheel_data.animation "Show Animation";
    annotation (Diagram, Icon(Ellipse(extent=[-92, 78; 92, -98], style(
            color=3,
            rgbcolor={0,0,255},
            gradient=3,
            fillColor=9,
            rgbfillColor={175,175,175})), Ellipse(extent=[-62, 50; 62, -70],
            style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))));
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_hub 
                                           annotation (extent=[-14, -16; 6, 4]);
    Modelica.Blocks.Interfaces.RealOutput Sensor[6] 
      annotation (extent=[80, -100; 100, -80]);
    Wheel_Road_Interaction Wheel_Road_Interaction1(
      p=Wheel_data.p,
      Kel=Wheel_data.Kel,
      Del=Wheel_data.Del,
      atanVx=Wheel_data.atanVx,
        WheelRadius=Wheel_data.Radius,
        ModelTyreRelaxation=Wheel_data.ModelTyreRelaxation,
      Pacejka_Friction_Data=Pacejka_Friction_Data) 
      annotation (extent=[-110,34; -44,96]);
    MotorcycleDynamics.Wheel.Friction_Model.Interfaces.Friction_Connector Pin  annotation (extent=[-88,-100; -68,-80]);
    Modelica.Mechanics.MultiBody.Visualizers.FixedFrame FixedFrame1(
      length=0.25,
      animation=true,
      showLabels=false,
      diameter=0.01,
        color_x={0,180,0},
        color_y={0,180,0},
        color_z={0,180,0}) 
                   annotation (extent=[32,-16; 52,4]);
    public 
    parameter Data.Base_Wheel_Data Wheel_data annotation (extent=[80,80; 100,100]);
    public 
      Modelica.Mechanics.MultiBody.Parts.BodyShape Wheel_Mass(
        animateSphere=false,
        m=Wheel_data.m,
        I_11=Wheel_data.I_11,
        I_22=Wheel_data.I_22,
        I_33=Wheel_data.I_33,
        I_21=Wheel_data.I_21,
        I_31=Wheel_data.I_31,
        I_32=Wheel_data.I_32,
        r_shape={0,-0.05,0},
        lengthDirection={0,1,0},
        widthDirection={1,0,0},
        color={100,100,100},
        width=Wheel_data.Radius*2,
        length=0.1,
        height=Wheel_data.Radius*2,
        animation=Wheel_data.animation,
        shapeType="pipe")    annotation (extent=[76,34; 100,58], rotation=270);
      parameter Boolean ModelTyreRelaxation=true 
        "If true the lateral tyre relaxaion will be modeled otherwise no.";
    parameter Friction_Model.Pacejka.Data.Base_Pacejka_Friction_Data 
        Pacejka_Friction_Data 
        "Relaxation Pacejka Friction Model Coefficient (They dipend from specific tyre). You must insert it even if you're using linear model instead.";
  equation 
    connect(Wheel_Road_Interaction1.Sensor, Sensor) annotation (points=[-47.3,
            37.72; -36,37.72; -36,-90; 90,-90],     style(color=3, rgbcolor={0,
            0,255}));
      connect(Wheel_Road_Interaction1.Pin, Pin) 
                                               annotation (points=[-78.98,42.06;
            -78.98,-30.36; -78,-30.36; -78,-90],      style(color=3, rgbcolor={
            0,0,255}));
    connect(frame_hub, FixedFrame1.frame_a) annotation (points=[-4,-6; 32,-6],
                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Wheel_Road_Interaction1.frame_b, frame_hub) annotation (points=[-47.3,
            68.1; -4,68.1; -4,-6],       style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Wheel_Road_Interaction1.frame_b, Wheel_Mass.frame_a) annotation (
          points=[-47.3,68.1; -20,68.1; -20,74; 88,74; 88,58],   style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
  end Standard_Wheel;
    
  model Wheel_Road_Interaction "The model of wheel-road interaction" 
      
  annotation (
  Documentation(info="<html>
<p> This class contain the tire and all fisical low inherent the wheel-road interaction.
<br> It has three foundamental aspect:
<ol>
<li> The acausality of equation that constitute the model;
<li> The presence of only one connector with that it can exchange the force with the outside;
<li> The casualness of the road that provide the value of altitude and the normal versor.
</ol>
</HTML>"));
      
      import Modelica.Mechanics.MultiBody.Frames.*;
      import Modelica.Math.*;
      
    parameter Boolean ModelTyreRelaxation = true 
        "If true the lateral tyre relaxayion will be modeled otherwise no.";
      
    parameter Real p=1.5 "tyre pressure [bar]";
    parameter Real WheelRadius=0.3 "Wheel Radius";
    parameter Real Kel=200000 "Pneumatic Elastic constant";
    parameter Real Del=1000 "Dumping Pneumatic Elastic constant";
    parameter Real atanVx=4 "10^x";
      
    constant Real pi=Modelica.Constants.pi;
      
    Real SlipAtan;
    Real P[3](start={0,0,0});
    Real POC[3];
    Orientation POC_R;
    Real POC_f[3];
    Real POC_t[3];
    Modelica.SIunits.Position r_rel_POC[3] 
        "Position vector from origin of POC to origin of frame_b resolved in frame_b";
      
    //contact "True if the tyre is in contact with the road";
    Real dx "POC translation due to longitudinal force";
    Real dy "POC translation due to transversal force";
    Real dz "Pneumatic deformation";
      
    Real fw "Rolling friction coefficient";
    Real fw_atan;
    Real fw_a;
    Real fw_b;
    Real fw_c;
      
    //roll "Inclinazione ruota rispetto a z assoluto (roll/camber angle)";
    Real alpha(start=0);
      
    Real V[3];
    Real signVx;
      
    //Parametri della retta di rotolamento della ruota nel piano della strada.
      
    //Wheel rotation axes.
    Real x_wheel[3];
    Real y_wheel[3];
    Real z_wheel[3];
      
    //POC axes.
    Real x_POC[3];
    Real y_POC[3];
    Real z_POC[3];
      
    //Vector length from P to frame_b.
    Real dist_z(start=WheelRadius);
      
    Real tau;
    Real idealsideslip;
      
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow POC_x(
      r=POC,
      r_head=x_POC*0.25,
      color={0,0,200},
        diameter=0.01) annotation (extent=[-40, 58; -20, 78]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow POC_z(
      r=POC,
      r_head=z_POC*0.25,
      color={0,0,200},
        diameter=0.01) annotation (extent=[-40, 20; -20, 40]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow POC_y(
      r=POC,
      r_head=y_POC*0.25,
      color={0,0,200},
        diameter=0.01) annotation (extent=[-40, 40; -20, 60]);
    public 
    Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_b "Frame Joint" 
      annotation (extent=[80, 0; 100, 20]);
    protected 
    outer MotorcycleDynamics.Environments.Road road;
     parameter Real omegaLow= 1.4/ WheelRadius;
    public 
    Modelica.Blocks.Interfaces.RealOutput Sensor[6] "0 Vx, 1 roll" 
      annotation (extent=[80, -98; 100, -78]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow Wheel_x(
      r_head=x_wheel*0.25,
      r=frame_b.r_0,
      color={255,255,0},
        diameter=0.01) annotation (extent=[-4, 60; 16, 80]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow Wheel_z(
      r_head=z_wheel*0.25,
      r=frame_b.r_0,
      color={255,255,0},
        diameter=0.01) annotation (extent=[-4, 22; 16, 42]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow Wheel_y(
      r_head=y_wheel*0.25,
      r=frame_b.r_0,
      color={255,255,0},
        diameter=0.01) annotation (extent=[-4, 42; 16, 62]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow P_x(
      r_head=x_POC*0.25,
      color={255,0,0},
      r=P,
        diameter=0.01) annotation (extent=[-70,58; -50,78]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow P_z(
      color={255,0,0},
      r_head=z_POC*0.25,
      r=P,
        diameter=0.01) annotation (extent=[-66,20; -46,40]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow P_y(
      r_head=y_POC*0.25,
      color={255,0,0},
      r=P,
        diameter=0.01) annotation (extent=[-68,40; -48,60]);
    Wheel.Friction_Model.Interfaces.Friction_Connector Pin annotation (extent=[-16,-84; 4,-64]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow Fx(
      r=POC,
      color={0,0,200},
      r_head=0.0008*x_POC*POC_f[1],
        diameter=0.02) annotation (extent=[-42,-10; -22,10]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow Fz(
      r=POC,
      color={0,0,200},
      r_head=0.05*z_POC*sqrt(POC_f[3]),
        diameter=0.02) annotation (extent=[-42,-48; -22,-28]);
    Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow Fy(
      r=POC,
      color={0,0,200},
      r_head=0.01*y_POC*POC_f[2],
        diameter=0.02) annotation (extent=[-42,-28; -22,-8]);
      parameter Friction_Model.Pacejka.Data.Base_Pacejka_Friction_Data 
        Pacejka_Friction_Data annotation (extent=[-100,80; -80,100]);
  equation 
    //HP: the road tangent plane is the same at P and POC
      
    //Wheel hub axes.
    y_wheel = resolve1(frame_b.R, {0,1,0});
    x_wheel = normalize(cross(y_wheel, z_POC));
    z_wheel = cross(x_wheel, y_wheel);
      
    //P and POC axes
    x_POC = x_wheel;
    y_POC = cross(z_POC, x_POC);
    z_POC = normalize({-road.get_nx(P[1], P[2]),-road.get_ny(P[1], P[2]),1});
      
    //dist_z = length(frame_b.r_0-P);
      
    P = frame_b.r_0 - dist_z*z_wheel;
    P[3] = road.get_z(P[1], P[2]);
      
    //POC Position.  
    POC = P + resolve1(POC_R, {dx,dy,0});
      
    //POC frame rotation constraints.
    POC_R = from_nxy(x_POC, y_POC);
      
    //FORCES PARAMETERS.
    //Velocità di P lungo i tre coseni direttori della terna di POC {x_POC,y_POC,z_POC}.
    V = resolve2(POC_R, der(P));
      
    //Vx sign.
    signVx = (atan(10^(atanVx)*V[1]))*2/pi;
      
    Pin.contact = (atan(-1e8*(dist_z - WheelRadius)) + pi/2)/pi;
      
    //Longitudinal POC Traslation due to speed.
    dx = fw*WheelRadius*signVx;
    dz = (dist_z - WheelRadius)*cos(Pin.roll);
    dy = (dist_z - WheelRadius)*sin(Pin.roll);
      
    //Current fw is a simplification.
    //fw = 0.0085 + 0.018/p + 0.00000159/p*V[1]^2;
    //fw= if abs(V[1]*3.6)<165 then 0.0085+0.018/p+0.00000159/p*(V[1]*3.6)^2 else 0.018/p+0.00000291/p*(V[1]*3.6)^2;
    //fw_atan is the equivalent of: 0 if V[1] < 165 Km/h else 1
    fw_atan = (atan(V[1]-165/3.6)+pi/2)/pi;
    fw_a = (1-fw_atan)*0.0085;
    fw_b = 0.0018;
    fw_c = 0.00000159 * (1-fw_atan) + 0.00000291 * fw_atan;
    fw = fw_a + fw_b/p + fw_c/p*(V[1]*3.6)^2;
      
    SlipAtan=((pi/2)+atan((V[1]-0.5)*1e12))/(pi)+((pi/2)+atan((-V[1]-0.5)*1e12))/(pi);
      
    //POC longitudinal forces.
    //Pin.slip = (frame_b.R.w[2]*WheelRadius - V[1]);
    Pin.slip = (1-SlipAtan)*(frame_b.R.w[2]*WheelRadius - V[1]) + (SlipAtan)*((frame_b.R.w[2]*WheelRadius - V[1])/abs(V[1]+1e-5));
      
    //POC Normal forces.
    Pin.N = -Pin.contact*(dz*Kel + der(dz)*Del);
      
    // RPY Angles.
    idealsideslip = (1-SlipAtan)*sin(alpha) + SlipAtan*alpha;
    //Pin.sideslip = (1-SlipAtan)*sin(alpha) + SlipAtan*alpha;
    alpha = -atan2(V[2], V[1]);
    Pin.roll = -atan2(z_wheel*y_POC, z_wheel*z_POC);
      
    if ModelTyreRelaxation then
      // Sistemare per velocità negative (magari con un istruzione if)
      //tau = pi/(frame_b.R.w[2]+1e-5)*(atan(1e12*(frame_b.R.w[2]-omegaLow))+pi/2)+pi/omegaLow *(atan(1e12*(-frame_b.R.w[2]+omegaLow))+pi/2);
      // +1e-5 da eliminare....
      //tau=(Pin.Kyalpha+1e-5)*(0.000008633+0.00000003725*V[1]-0.0000000008389*(V[1])^2) / (V[1]+1e-5);
      tau=(Pin.Kyalpha+1e-5)*(Pacejka_Friction_Data.tyre_rel_coeff_a+Pacejka_Friction_Data.tyre_rel_coeff_b*V[1]+Pacejka_Friction_Data.tyre_rel_coeff_c*(V[1])^2) / (V[1]+1e-5);
        
      der(Pin.sideslip) = 1 / tau*(idealsideslip-Pin.sideslip);
    else
      tau = 0;
      Pin.sideslip = idealsideslip;
    end if;
      
    //It's assumed that forces are applied to POC frame and torques at frame_b.
    //POC Forces.
    POC_f[1] = road.get_mue(P[1], P[2])*Pin.TF;
    POC_f[2] = road.get_mue(P[1], P[2])*Pin.Fs;
    POC_f[3] = Pin.N;
      
    //sigma=atan2(dx,1);
      
    POC_t[1] = 0;
    POC_t[2] = 0;
    POC_t[3] = Pin.Mz;
      
    //Force and torque BALANCE at POC frame.
    r_rel_POC = resolve2(POC_R, POC - frame_b.r_0);
      
    zeros(3) = frame_b.f + resolve2(frame_b.R, resolve1(POC_R, POC_f));
    zeros(3) = frame_b.t + resolve2(frame_b.R, resolve1(POC_R, POC_t + cross(r_rel_POC, POC_f)));
    annotation (
      uses(                            Modelica(version="2.2")),
      Diagram,
      DymolaStoredErrors,
      Icon(
        Ellipse(extent=[-70, 98; 62, -36], style(
            color=3,
            rgbcolor={0,0,255},
            gradient=3,
            fillColor=9,
            rgbfillColor={175,175,175})),
        Line(points=[-76, -38; 72, -38], style(color=3, rgbcolor={0,0,255})),
        Line(points=[-6, -78; -6, -40; -10, -48; -2, -48; -6, -40], style(
            color=3,
            rgbcolor={0,0,255},
            gradient=1,
            fillColor=0,
            rgbfillColor={0,0,0})),
        Ellipse(extent=[-54, 84; 46, -22], style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=7,
            rgbfillColor={255,255,255}))),
      experiment(
        StopTime=10,
        NumberOfIntervals=5000,
        Tolerance=1e-012),
      experimentSetupOutput);
  algorithm 
    Sensor[1]        := P[1];
    Sensor[2]        := P[2];
    Sensor[3]        := P[3];
    Sensor[4]        := V[1];
    Sensor[5]        := atan2(x_POC[2], x_POC[1]);
    Sensor[6]        := Pin.roll;
    when abs(Pin.roll)>(pi/2)*0.9 then
                                        terminate("CADUTA!!! Il pilota ti supplica di non esagerare con il gas, sii pi&ugrave; prudente!");
                                                                 end when;
  end Wheel_Road_Interaction;
    
    package Data 
      record Base_Wheel_Data 
        
      annotation (
      Documentation(info="<html>
<p> This record contains the data related the wheel inertia, the wheel mass, the wheel dimension, the elastic coefficient and damper of the wheel. 
</HTML>"));
        
        annotation (
        defaultComponentName="Wheel_data");
        parameter Boolean ModelTyreRelaxation = true 
          "If true the lateral tyre relaxaion will be modeled otherwise no.";
        parameter Real Radius = 0.3 "Wheel Radius";
        parameter Real Kel = 140000 "Pneumatic Elastic Constant";
        parameter Real Del = 40000 "Pneumatic Dumping Constant";
        parameter Modelica.SIunits.Inertia I_11 = 0.383 "Inertia tensor xx";
        parameter Modelica.SIunits.Inertia I_22 = 0.638 "Inertia tensor yy";
        parameter Modelica.SIunits.Inertia I_33 = 0.383 "Inertia tensor zz";
        parameter Modelica.SIunits.Inertia I_21 = 0 "Inertia tensor yx";
        parameter Modelica.SIunits.Inertia I_31 = 0 "Inertia tensor zx";
        parameter Modelica.SIunits.Inertia I_32 = 0 "Inertia tensor zy";
        parameter Modelica.SIunits.Mass m = 10 "Wheel mass";
        parameter Real p = 1.5 "tyre pressure [bar]";
        parameter Real atanVx = 4 "10^x";
        parameter Boolean animation = true "Show Animation";
      end Base_Wheel_Data;
      
      record Supermotard_Rear_Wheel_Data 
        
      annotation (
      Documentation(info="<html>
<p> This record contains the data related of the particular wheel inertia, the wheel mass, the wheel dimension, the elastic coefficient and damper of the wheel. 
</HTML>"));
        
        extends Base_Wheel_Data(
          ModelTyreRelaxation=true,
          Radius=0.3,
          Kel=140000,
          Del=40000,
          I_11=0.383,
          I_22=0.686,
          I_33=0.383,
          I_21=0,
          I_31=0,
          I_32=0,
          m=14.7,
          p=1.5,
          atanVx=4,
          animation=true);
        annotation (
          defaultComponentName="Rear_Wheel_data");
        
      end Supermotard_Rear_Wheel_Data;
      
      record Supermotard_Front_Wheel_Data 
        
      annotation (
      Documentation(info="<html>
<p> This record contains the data related of the particular wheel inertia, the wheel mass, the wheel dimension, the elastic coefficient and damper of the wheel. 
</HTML>"));
        
        extends Base_Wheel_Data(
          ModelTyreRelaxation=true,
          Radius=0.3,
          Kel=140000,
          Del=40000,
          I_11=0.270,
          I_22=0.484,
          I_33=0.270,
          I_21=0,
          I_31=0,
          I_32=0,
          m=11.9,
          p=1.5,
          atanVx=4,
          animation=true);
        annotation (
          defaultComponentName="Front_Wheel_data");
      end Supermotard_Front_Wheel_Data;
      
      record KTM_950_Front_Wheel_Data 
        
      annotation (
      Documentation(info="<html>
<p> This record contains the data related of the particular wheel inertia, the wheel mass, the wheel dimension, the elastic coefficient and damper of the wheel. 
</HTML>"));
        
      annotation (
          defaultComponentName="Front_Wheel_data",
          defaultPrefixes="private");
        extends Base_Wheel_Data(
          ModelTyreRelaxation=true,
          Radius=0.345,
          Kel=140000,
          Del=40000,
          I_11=0.270,
          I_22=0.484,
          I_33=0.270,
          I_21=0,
          I_31=0,
          I_32=0,
          m=12.14,
          p=2.2,
          atanVx=4,
          animation=true);
      end KTM_950_Front_Wheel_Data;
      
      record KTM_950_Rear_Wheel_Data 
        
      annotation (
      Documentation(info="<html>
<p> This record contains the data related of the particular wheel inertia, the wheel mass, the wheel dimension, the elastic coefficient and damper of the wheel. 
</HTML>"));
        
       annotation (
          defaultComponentName="Rear_Wheel_data");
        extends Base_Wheel_Data(
          ModelTyreRelaxation=true,
          Radius=0.327,
          Kel=140000,
          Del=40000,
          I_11=0.383,
          I_22=0.686,
          I_33=0.383,
          I_21=0,
          I_31=0,
          I_32=0,
          m=15.68,
          p=2.4,
          atanVx=4,
          animation=true);
      end KTM_950_Rear_Wheel_Data;
      
    end Data;
    
  package Friction_Model 
      
  annotation (
  Documentation(info="<html>
<p> This package contain two type of friction model:
<ul>
<li> Linear model;
<li> Pacejka model.
</ul>
This type of friction is perfectly interchangeable thanks to the Friction connector.
</HTML>"));
      
    package Linear 
      annotation (
    Documentation(info="<html>
<p> The traction force is obtained from:
<ul>
  <li> TF = K * Slip.
    <br> where: 
    <ul>
      <li>K : it is a coefficient characteristic pendency;
      <li>Slip: it is the sliding.
    </ul>
</ul>
<p> The side force is obtained from:
<ul> 
  <li> FS = contact * ( Kl * lambda - Kt * roll ) * N.
      <br>where:
    <ul>
      <li>contact: is a variable that assumes value between 0 and 1 and identify the the contact between road and tyre;
      <li>Kl and Kt: are the constant;
      <li>lambda: is the angle between the x and y speed component;
      <li>roll: is the rolling angle.
   </ul>
  </ul>
</ul>
</HTML>"));
    model Linear_Friction_Model 
          "This model is very simple, it considers selfalign moment among z-axis equal to zero." 
          import Modelica.Mechanics.MultiBody.Frames.*;
          import Modelica.Math.*;
          
      constant Real pi=Modelica.Constants.pi;
          
      parameter Real k=10000 "Slip constant";
      parameter Real Kl=11 "Lateral force formula constant";
      parameter Real Kt=0.93 "Lateral force formula constant";
          
      Wheel.Friction_Model.Interfaces.Friction_Connector Pin annotation (extent=[-10,80; 10,100]);
    equation 
          
      //POC longitudinal forces.
      Pin.TF = Pin.contact*k*Pin.slip;
          
      //POC lateral forces.
      Pin.Fs = Pin.contact*(Kl*Pin.sideslip - Kt*Pin.roll)*Pin.N;
      Pin.Mz=0;
      //This is an approsimation it must be Pin.Kyalpha*pi*0.3*w.
      Pin.Kyalpha=1.5*1e4;
          
      annotation (Diagram, Icon);
    end Linear_Friction_Model;
    end Linear;
      
    package Pacejka 
        
      annotation (
    Documentation(info="<html>
<p> The traction force and the side force are obtained from magic formula.
</HTML>"));
        
    model Pacejka_Friction_Model 
          "In this model is defined a very detailed Pacejka friction model." 
          import Modelica.Mechanics.MultiBody.Frames.*;
          import Modelica.Math.*;
          
      constant Real pi=Modelica.Constants.pi;
          
      //Longitudinal Pacejka parameters
      Real Cx =        Pacejka_Friction_Data.Cx;
      Real pdx1 =      Pacejka_Friction_Data.pdx1;
      Real pdx2 =      Pacejka_Friction_Data.pdx2;
      Real pex1 =      Pacejka_Friction_Data.pex1;
      Real pex2 =      Pacejka_Friction_Data.pex2;
      Real pex3 =      Pacejka_Friction_Data.pex3;
      Real pex4 =      Pacejka_Friction_Data.pex4;
      Real pkx1 =      Pacejka_Friction_Data.pkx1;
      Real pkx2 =      Pacejka_Friction_Data.pkx2;
      Real pkx3 =      Pacejka_Friction_Data.pkx3;
      // sideslip dependency
      Real Cxalpha =   Pacejka_Friction_Data.Cxalpha;
      Real rbx1 =      Pacejka_Friction_Data.rbx1;
      Real rbx2 =      Pacejka_Friction_Data.rbx2;
          
      Real Cy =        Pacejka_Friction_Data.Cy;
      Real pdy1 =      Pacejka_Friction_Data.pdy1;
      Real pdy2 =      Pacejka_Friction_Data.pdy2;
      Real pdy3 =      Pacejka_Friction_Data.pdy3;
      Real pey1 =      Pacejka_Friction_Data.pey1;
      Real pey2 =      Pacejka_Friction_Data.pey2;
      Real pey4 =      Pacejka_Friction_Data.pey4;
      Real pky1 =      Pacejka_Friction_Data.pky1;
      Real pky2 =      Pacejka_Friction_Data.pky2;
      Real pky3 =      Pacejka_Friction_Data.pky3;
      Real pky4 =      Pacejka_Friction_Data.pky4;
      Real Cgamma =    Pacejka_Friction_Data.Cgamma;
      Real pky5 =      Pacejka_Friction_Data.pky5;
      Real pky6 =      Pacejka_Friction_Data.pky6;
      Real pky7 =      Pacejka_Friction_Data.pky7;
      Real Egamma =    Pacejka_Friction_Data.Egamma;
      // longitudinal slip dependency
      Real rby1 =      Pacejka_Friction_Data.rby1;
      Real rby2 =      Pacejka_Friction_Data.rby2;
      Real rby3 =      Pacejka_Friction_Data.rby3;
      Real Cyk =       Pacejka_Friction_Data.Cyk;
          
      //self-alignment parameters.
      Real R0 =        Pacejka_Friction_Data.R0;
      Real Ct =        Pacejka_Friction_Data.Ct;
      Real qbz1 =      Pacejka_Friction_Data.qbz1;
      Real qbz2 =      Pacejka_Friction_Data.qbz2;
      Real qbz5 =      Pacejka_Friction_Data.qbz5;
      Real qbz6 =      Pacejka_Friction_Data.qbz6;
      Real qbz9 =      Pacejka_Friction_Data.qbz9;
      Real qbz10 =     Pacejka_Friction_Data.qbz10;
      Real qdz1 =      Pacejka_Friction_Data.qdz1;
      Real qdz2 =      Pacejka_Friction_Data.qdz2;
      Real qdz3 =      Pacejka_Friction_Data.qdz3;
      Real qdz4 =      Pacejka_Friction_Data.qdz4;
      Real qdz8 =      Pacejka_Friction_Data.qdz8;
      Real qdz9 =      Pacejka_Friction_Data.qdz9;
      Real qdz10 =     Pacejka_Friction_Data.qdz10;
      Real qdz11 =     Pacejka_Friction_Data.qdz11;
      Real qez1 =      Pacejka_Friction_Data.qez1;
      Real qez2 =      Pacejka_Friction_Data.qez2;
      Real qez5 =      Pacejka_Friction_Data.qez5;
      Real qhz3 =      Pacejka_Friction_Data.qhz3;
      Real qhz4 =      Pacejka_Friction_Data.qhz4;
          
      // nominal vertical load DA CALCOLARE POI PER IL NOSTRO CASO    
      parameter Real Fz0=1600 "nominal vertical load [N]";
          
      Real dfz;
      Real Bt;
      Real lambdat;
      Real arg;
      Real Dt;
      Real Mz;
      Real Mzr;
      Real Fy0gamma0;
      Real Fygamma0;
      Real Dr;
      Real lambdar;
      Real Et;
      Real Br;
      Real Shr;
      Real Dx;
      Real Ex;
      Real Kxk;
      Real fact;
      Real Fx0;
      Real Bxalpha;
      Real Bx;
      Real fact1;
      Real fact2;
      Real Dy;
      Real Ey;
     // Real Kyalpha;
      Real By;
      Real Kygamma;
      Real Kyalphagamma0;
      Real Bgamma;
      Real Fy0;
      Real Byk;
      Real signSlip;
      Real signSideslip;
          
      Real Cyroll=1.0533;
          
      Wheel.Friction_Model.Interfaces.Friction_Connector Pin annotation (extent=[-10,80; 10,100]);
        protected 
      parameter Data.Base_Pacejka_Friction_Data Pacejka_Friction_Data 
        annotation (extent=[80,80; 100,100]);
    equation 
      //signSlip = sign(slip);
      signSlip = (atan(10^6*(Pin.slip)))*2/pi;
          
      dfz=(Pin.N-Fz0)/Fz0;
      Dx=(pdx1+pdx2*dfz)*Pin.N;
      Ex=(pex1+pex2*dfz+pex3*dfz^2)*(1-pex4*signSlip);
      Kxk=Pin.N*(pkx1+pkx2*dfz)*exp(pkx3*dfz);
      Bx=Kxk/(Cx*Dx);
      //longitudinal force as function of the longitudinal slip
      fact=atan(Bx*Pin.slip-Ex*(Bx*Pin.slip-atan(Bx*Pin.slip)));
      Fx0=Dx*sin(Cx*fact);
      //final longitudinal force with sideslip effects
      Bxalpha=rbx1*cos(atan(rbx2*Pin.slip));
      Pin.TF=cos(Cxalpha*atan(Bxalpha*Pin.sideslip))*Fx0*Pin.contact;
          
      //signSideslip = sign(sideslip);
      signSideslip = (atan(10^6*(Pin.sideslip)))*2/pi;
          
    //  camber=roll;
      Dy=Pin.N*pdy1*exp(pdy2*dfz)/(1+pdy3*Pin.roll^2);
      Ey=pey1+pey2*Pin.roll^2+pey4*Pin.roll*signSideslip;
      Pin.Kyalpha=pky1*Fz0*sin(pky2*atan(Pin.N/((pky3+pky4*Pin.roll^2)*Fz0)))/(1+pky5*Pin.roll^2);
      By=Pin.Kyalpha/(Cy*Dy);
      Kygamma=(pky6+pky7*dfz)*Pin.N;
      Bgamma=Kygamma/(Cgamma*Dy);
          
      //lateral force as function of the sideslip and camber
      fact1=Cy*atan(By*Pin.sideslip-Ey*(By*Pin.sideslip-atan(By*Pin.sideslip)));
      fact2=Bgamma*Pin.roll-Egamma*(Bgamma*Pin.roll-atan(Bgamma*Pin.roll));
      Fy0=Dy*sin(fact1)+Cgamma*atan(fact2);
      //final expression of longitudinal force as function for the longitudinal slip 
      Byk=rby1*cos(atan(rby2*(Pin.sideslip-rby3)));
      Pin.Fs=cos(Cyk*atan(Byk*Pin.slip))*Fy0*Pin.contact;
          
      //self-alignment moment
      Kyalphagamma0 = pky1*Fz0*sin(pky2*atan(Pin.N/(pky3*Fz0)));
      Br=qbz9+qbz10*By*Cy;
      Bt=(qbz1+qbz2*dfz)*(1+qbz5*sign(Pin.roll)+qbz6*Pin.roll^2);
      lambdat = (Pin.sideslip^2 + (Kxk* Pin.slip / Kyalphagamma0)^2)^0.5 * signSideslip;
      arg = Bt*lambdat;
      Dt = Pin.N*(R0/Fz0)*(qdz1+qdz2*dfz)*(1+qdz3*sign(Pin.roll)+qdz4*Pin.roll^2);
      Et=(qez1+qez2*dfz)*(1+qez5*Pin.roll*(2/pi)*atan(Bt*Ct*Pin.sideslip));
      Mz = (-Dt * cos(Ct * atan(arg - Et * (arg -atan(arg)))))/(1+Pin.sideslip^2)^0.5 * Fygamma0 + Mzr;
      Fygamma0 = cos(Cyroll * atan(Byk * Pin.slip)) * Fy0gamma0;
      Fy0gamma0=Dy*sin(fact1);
      Dr=Pin.N*R0*((qdz8+qdz9*dfz)*Pin.roll+(qdz10+qdz11*dfz)*Pin.roll*abs(Pin.roll))/(1+Pin.sideslip^2)^0.5;
      Mzr= Dr * cos( atan(Br * lambdar));
      Shr=(qhz3+qhz4*dfz)*Pin.roll;
      lambdar = ((Pin.sideslip+Shr)^2+(Kxk* Pin.slip / Kyalphagamma0)^2)^0.5 * sign(Pin.sideslip+Shr);
      Pin.Mz=-Mz*Pin.contact;
          
      annotation (Diagram, Icon);
    end Pacejka_Friction_Model;
        
      package Data 
        record Base_Pacejka_Friction_Data 
            
          annotation (
          defaultComponentName="Pacejka_Friction_Data");
          //Tyre relaxatin coefficients.
          parameter Real tyre_rel_coeff_a = 0.000008633;
          parameter Real tyre_rel_coeff_b = -0.00000003725;
          parameter Real tyre_rel_coeff_c = 0.0000000008389;
            
          //Longitudinal Pacejka parameters
          parameter Real Cx= 1.6064;
          parameter Real pdx1= 1.2017;
          parameter Real pdx2= -0.0922;
          parameter Real pex1= 0.0263;
          parameter Real pex2= 0.27056;
          parameter Real pex3= -0.0769;
          parameter Real pex4= 1.1268;
          parameter Real pkx1= 25.94;
          parameter Real pkx2= -4.233;
          parameter Real pkx3= 0.3369;
          // sideslip dependency
          parameter Real Cxalpha= 1.1231;
          parameter Real rbx1= 13.476;
          parameter Real rbx2= 11.354;
            
          parameter Real Cy=0.93921;
          parameter Real pdy1=1.1524;
          parameter Real pdy2=-0.01794;
          parameter Real pdy3=-0.06531;
          parameter Real pey1=-0.94635;
          parameter Real pey2=-0.09845;
          parameter Real pey4=-1.6416;
          parameter Real pky1=26.601;
          parameter Real pky2=1.0167;
          parameter Real pky3=1.4989;
          parameter Real pky4=0.52567;
          parameter Real Cgamma=0.50732;
          parameter Real pky5=-0.24064;
          parameter Real pky6=0.7667;
          parameter Real pky7=0;
          parameter Real Egamma=-4.7481;
          // longitudinal slip dependency
          parameter Real rby1=7.7856;
          parameter Real rby2=8.1697;
          parameter Real rby3=-0.05914;
          parameter Real Cyk=1.0533;
            
          //auto-alignment parameter
          //Tyre crown radius (derives from the cross-sectional geometry)
          parameter Real R0= 0.08;
          parameter Real Ct =     1.0917;
          parameter Real qbz1 =  10.486;
          parameter Real qbz2 =  -0.001154;
          parameter Real qbz5 =  -0.68793;
          parameter Real qbz6 =   1.0411;
          parameter Real qbz9 =  27.445;
          parameter Real qbz10 = -1.0792;
          parameter Real qdz1 =   0.19796;
          parameter Real qdz2 =   0.06563;
          parameter Real qdz3 =   0.2199;
          parameter Real qdz4 =   0.21866;
          parameter Real qdz8 =   0.3682;
          parameter Real qdz9 =   0.1218;
          parameter Real qdz10 =  0.25439;
          parameter Real qdz11 = -0.17873;
          parameter Real qez1 =  -0.91586;
          parameter Real qez2 =   0.11625;
          parameter Real qez5 =   1.4387;
          parameter Real qhz3 =  -0.003789;
          parameter Real qhz4 =  -0.01557;
            
        end Base_Pacejka_Friction_Data;
          
        record Pacejka_120_70_ZR_17_Data 
                                           annotation (
          defaultComponentName="Pacejka_120_70_ZR_17_Data");
            
          extends Base_Pacejka_Friction_Data(
              Cy =         0.8327,
              pdy1 =       1.3,
              pdy2 =       0,
              pdy3 =       0,
              pey1 =      -1.2556,
              pey2 =      -3.2068,
              pey4 =      -3.998,
              pky1 =      22.841,
              pky2 =       2.1578,
              pky3 =       2.5058,
              pky4 =      -0.08088,
              pky5 =      -0.22882,
              Cgamma =     0.867565,
              pky6 =       0.69677,
              pky7 =      -0.03077,
              Egamma =   -15.815,
              R0 =         0.06,
              Ct =         1.0917,
              qbz1 =      10.486,
              qbz2 =      -0.001154,
              qbz5 =      -0.68973,
              qbz6 =       1.0411,
              qbz9 =      27.445,
              qbz10 =     -1.0792,
              qdz1 =       0.19796,
              qdz2 =       0.06563,
              qdz3 =       0.2199,
              qdz4 =       0.21866,
              qdz8 =       0.3682,
              qdz9 =       0.1218,
              qdz10 =      0.25439,
              qdz11 =     -0.17873,
              qez1 =      -0.91586,
              qez2 =       0.11625,
              qez5 =       1.4387,
              qhz3 =      -0.003789,
              qhz4 =      -0.009862);
            
        end Pacejka_120_70_ZR_17_Data;
          
        record Pacejka_160_70_ZR_17_Data 
                                          annotation (
          defaultComponentName="Pacejka_160_70_ZR_17_Data");
          extends Base_Pacejka_Friction_Data(
              Cy =         0.93921,
              pdy1 =       1.1524,
              pdy2 =      -0.01794,
              pdy3 =      -0.06531,
              pey1 =      -0.94635,
              pey2 =      -0.09845,
              pey4 =      -1.6416,
              pky1 =      26.601,
              pky2 =       1.0167,
              pky3 =       1.4989,
              pky4 =       0.52567,
              pky5 =      -0.24064,
              Cgamma =     0.50732,
              pky6 =       0.7667,
              pky7 =       0,
              Egamma =    -4.7481,
              R0 =         0.08,
              Ct =         1.3115,
              qbz1 =      10.354,
              qbz2 =       4.3004,
              qbz5 =      -0.34033,
              qbz6 =      -0.13202,
              qbz9 =      10.118,
              qbz10 =     -1.0508,
              qdz1 =       0.20059,
              qdz2 =       0.05282,
              qdz3 =      -0.21116,
              qdz4 =      -0.15941,
              qdz8 =       0.30941,
              qdz9 =       0,
              qdz10 =      0.10037,
              qdz11 =      0,
              qez1 =      -3.9247,
              qez2 =      10.809,
              qez5 =       0.9836,
              qhz3 =      -0.04908,
              qhz4 =       0);
        end Pacejka_160_70_ZR_17_Data;
          
        record Pacejka_180_55_ZR_17_Data 
            
                                          annotation (
          defaultComponentName="Pacejka_180_55_ZR_17_Data");
          extends Base_Pacejka_Friction_Data(
              tyre_rel_coeff_a = 0.000009694,
              tyre_rel_coeff_b = -0.00000001333,
              tyre_rel_coeff_c = 0.000000001898,
              Cy =            0.9,
              pdy1 =          1.3,
              pdy2 =          0,
              pdy3 =          0,
              pey1 =         -2.2227,
              pey2 =         -1.669,
              pey4 =         -4.288,
              pky1 =         15.791,
              pky2 =          1.6935,
              pky3 =          1.4604,
              pky4 =          0.669,
              pky5 =          0.18708,
              Cgamma =        0.61397,
              pky6 =          0.45512,
              pky7 =          0.013293,
              Egamma =      -19.99,
              R0 =            0.09,
              Ct =            1.3153,
              qbz1 =         10.041,
              qbz2 =          1.61e-8,
              qbz5 =         -0.76784,
              qbz6 =         -0.73422,
              qbz9 =         16.39,
              qbz10 =        -0.35549,
              qdz1 =          0.26331,
              qdz2 =          0.030987,
              qdz3 =         -0.62013,
              qdz4 =         -0.98524,
              qdz8 =          0.50443,
              qdz9 =          0.36312,
              qdz10 =        -0.19168,
              qdz11 =        -0.40709,
              qez1 =         -0.19924,
              qez2 =         -0.017638,
              qez5 =          3.6511,
              qhz3 =         -0.028448,
              qhz4 =         -0.009862);
            
        end Pacejka_180_55_ZR_17_Data;
      end Data;
    end Pacejka;
      
  package Interfaces 
        
  connector Friction_Connector 
  annotation (
  Documentation(info="<html>
<p> Interface connection between interaction model and friction model
</HTML>"));
    Modelica.Blocks.Interfaces.RealSignal TF 
                                           annotation (extent=[80,36; 100,56]);
    Modelica.Blocks.Interfaces.RealSignal Fs 
                                           annotation (extent=[80,58; 100,78]);
    Modelica.Blocks.Interfaces.RealSignal N 
                                          annotation (extent=[80,-8; 100,12]);
    Modelica.Blocks.Interfaces.RealSignal slip 
      annotation (extent=[80,-30; 100,-10]);
    Modelica.Blocks.Interfaces.RealSignal sideslip 
      annotation (extent=[80,-52; 100,-32]);
    Modelica.Blocks.Interfaces.RealSignal contact 
      annotation (extent=[80,80; 100,100]);
    Modelica.Blocks.Interfaces.RealSignal roll 
      annotation (extent=[80,-74; 100,-54]);
    annotation (Icon(Rectangle(extent=[-100,100; 100,-100],
                                                        style(
            color=3,
            rgbcolor={0,0,255},
            fillColor=51,
            rgbfillColor={255,255,85}))), Diagram);
    Modelica.Blocks.Interfaces.RealSignal Mz 
      annotation (extent=[80,14; 100,34]);
    Modelica.Blocks.Interfaces.RealSignal Kyalpha 
      annotation (extent=[80,-100; 100,-80]);
  end Friction_Connector;
        
  end Interfaces;
      
  end Friction_Model;
    
    model Visualizer 
      Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape1(
        widthDirection={0,0,1},
        lengthDirection={1,0,0},
        color={0,0,0},
        animation=true,
        shapeType=dxf_no) annotation (extent=[8,-100; 28,-80]);
      Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape2(
        widthDirection={0,0,1},
        lengthDirection={1,0,0},
        color={0,0,0},
        animation=true,
        shapeType=dxf_no) annotation (extent=[8,-76; 28,-56]);
      Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation1(
        angle=5,
        angles={0,0,0},
        n={0,1,0}) annotation (extent=[-22,-76; -2,-56]);
      Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape3(
        widthDirection={0,0,1},
        lengthDirection={1,0,0},
        color={0,0,0},
        animation=true,
        shapeType=dxf_no) annotation (extent=[-78,8; -58,28],  rotation=90);
      Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape4(
        widthDirection={0,0,1},
        lengthDirection={1,0,0},
        color={0,0,0},
        animation=true,
        shapeType=dxf_no) annotation (extent=[-108,8; -88,28],  rotation=90);
      Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation3(
        angles={0,0,0},
        n={0,1,0},
        angle=35)  annotation (extent=[-108,-28; -88,-8],  rotation=90);
      Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation2(
        angles={0,0,0},
        n={0,1,0},
        angle=30)  annotation (extent=[-78,-26; -58,-6],  rotation=90);
      annotation (Diagram);
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a1 
        annotation (extent=[-108,-100; -88,-80]);
      Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape5(
        widthDirection={0,0,1},
        lengthDirection={1,0,0},
        color={0,0,0},
        animation=true,
        shapeType=dxf_no) annotation (extent=[8,-44; 28,-24]);
      Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation4(
        angles={0,0,0},
        n={0,1,0},
        angle=10)  annotation (extent=[-22,-44; -2,-24]);
    parameter String dxf_no = "1";
      Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape6(
        widthDirection={0,0,1},
        lengthDirection={1,0,0},
        color={0,0,0},
        animation=true,
        shapeType=dxf_no) annotation (extent=[6,-16; 26,4]);
      Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation5(
        angles={0,0,0},
        n={0,1,0},
        angle=15)  annotation (extent=[-24,-16; -4,4]);
      Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape7(
        widthDirection={0,0,1},
        lengthDirection={1,0,0},
        color={0,0,0},
        animation=true,
        shapeType=dxf_no) annotation (extent=[4,12; 24,32]);
      Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation6(
        angles={0,0,0},
        n={0,1,0},
        angle=20)  annotation (extent=[-26,12; -6,32]);
      Modelica.Mechanics.MultiBody.Visualizers.FixedShape FixedShape8(
        widthDirection={0,0,1},
        lengthDirection={1,0,0},
        color={0,0,0},
        animation=true,
        shapeType=dxf_no) annotation (extent=[2,40; 22,60]);
      Modelica.Mechanics.MultiBody.Parts.FixedRotation FixedRotation7(
        angles={0,0,0},
        n={0,1,0},
        angle=25)  annotation (extent=[-28,40; -8,60]);
    equation 
      connect(FixedShape3.frame_a, FixedRotation2.frame_b) annotation (points=[-68,7;
            -68,-5],        style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation2.frame_a, frame_a1) annotation (points=[-68,-27; -68,
            -90; -98,-90],     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(frame_a1, FixedRotation1.frame_a) annotation (points=[-98,-90; -52,
            -90; -52,-66; -23,-66],     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(frame_a1, FixedShape1.frame_a) annotation (points=[-98,-90; 7,-90],
          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(frame_a1, FixedRotation3.frame_a) annotation (points=[-98,-90; -98,
            -29],     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation1.frame_b, FixedShape2.frame_a) annotation (points=[-1,-66;
            7,-66],         style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(frame_a1, FixedRotation4.frame_a) annotation (points=[-98,-90; -52,
            -90; -52,-34; -23,-34],     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation4.frame_b, FixedShape5.frame_a) annotation (points=[-1,-34;
            7,-34],         style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedShape4.frame_a, FixedRotation3.frame_b) annotation (points=[-98,7;
            -98,-7],        style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation5.frame_b, FixedShape6.frame_a) annotation (points=[-3,-6; 5,
            -6],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation6.frame_b, FixedShape7.frame_a) annotation (points=[-5,22; 3,
            22],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation7.frame_b, FixedShape8.frame_a) annotation (points=[-7,50; 1,
            50],          style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation5.frame_a, frame_a1) annotation (points=[-25,-6; -52,-6;
            -52,-90; -98,-90],     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation6.frame_a, frame_a1) annotation (points=[-27,22; -52,22;
            -52,-90; -98,-90],     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(FixedRotation7.frame_a, frame_a1) annotation (points=[-29,50; -52,50;
            -52,-90; -98,-90],     style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
    end Visualizer;
  end Wheel;
  
  package Driver 
    "This class provides various pilot model that it control the motorbike acting on steering gear and accelerator" 
    
  annotation (
  Documentation(info="<html>
<p> This package define all that is contained in the motorcycle control.
</HTML>"));
    
  model Passive_Driver 
      parameter Modelica.SIunits.Mass Upper_Body_Mass=43;
      parameter Modelica.SIunits.Mass Lower_Body_Mass=25.83;
      
    Modelica.Mechanics.MultiBody.Parts.Body Lower_Body(
      I_11=0.5,
      I_22=0.5,
      I_33=0.5,
      cylinderDiameter=0,
        m=Lower_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.F_dx,0,-Dimension_MassPosition_data.
            F_dy}) 
                annotation (extent=[-30,-54; -10,-34],
                                                     rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Upper_Body(
      I_11=1.428,
      I_22=1.347,
      I_33=0.916,
      I_31=0.433,
      cylinderDiameter=0,
        m=Upper_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.G_dx,0,Dimension_MassPosition_data.
            G_dy})              annotation (extent=[-30,4; -10,24],  rotation=
          90);
    annotation (Diagram, Icon);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Seaddle 
      annotation (extent=[-20,-100; 0,-80]);
      
      inner parameter Base_Dimension_MassPosition_Data 
        Dimension_MassPosition_data annotation (extent=[80,80; 100,100]);
  equation 
    connect(frame_Seaddle, Lower_Body.frame_a) annotation (points=[-10,-90; -60,
            -90; -60,-24; -20,-24; -20,-34],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Upper_Body.frame_a, Lower_Body.frame_a) annotation (points=[-20,4;
            -20,-34; -20,-34], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
  end Passive_Driver;
    
  model Standard_Driver 
      parameter Modelica.SIunits.Mass Upper_Body_Mass=43;
      parameter Modelica.SIunits.Mass Lower_Body_Mass=25.83;
      
    Modelica.Mechanics.MultiBody.Parts.Body Lower_Body(
      I_11=0.5,
      I_22=0.5,
      I_33=0.5,
      cylinderDiameter=0,
        m=Lower_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.F_dx,0,-Dimension_MassPosition_data.
            F_dy}) 
                annotation (extent=[-30,-54; -10,-34],
                                                     rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Upper_Body(
      I_11=1.428,
      I_22=1.347,
      I_33=0.916,
      I_31=0.433,
      cylinderDiameter=0,
        m=Upper_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.G_dx,0,Dimension_MassPosition_data.
            G_dy})              annotation (extent=[-30,-12; -10,8], rotation=
          90);
    annotation (Diagram, Icon);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Seaddle 
      annotation (extent=[-20,-100; 0,-80]);
    Modelica.Blocks.Interfaces.RealInput Sensor1[6] 
      annotation (extent=[-100,-20; -80,0]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steering 
      annotation (extent=[80,20; 100,40]);
      Steering_Control.Gain_Steer_Control_Marescotti Gain_Steer_Control1(k2=8) 
        annotation (extent=[8,30; 42,58]);
      Modelica.Blocks.Interfaces.RealInput u1[2] 
        annotation (extent=[-100,70; -80,90]);
    protected 
      outer Base_Dimension_MassPosition_Data Dimension_MassPosition_data 
        annotation (extent=[80,80; 100,100]);
  equation 
    connect(Lower_Body.frame_a, Upper_Body.frame_a) annotation (points=[-20,-34;
            -20,-23; -20,-12; -20,-12],
                   style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_Seaddle, Lower_Body.frame_a) annotation (points=[-10,-90; -60,
            -90; -60,-24; -20,-24; -20,-34],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Gain_Steer_Control1.Sensor, Sensor1) annotation (points=[9.7,
            38.12; -66,38.12; -66,-10; -90,-10], style(color=74, rgbcolor={0,0,
              127}));
      connect(Gain_Steer_Control1.flange_steer, flange_steering) annotation (
          points=[40.3,31.4; 65.15,31.4; 65.15,30; 90,30], style(color=0,
            rgbcolor={0,0,0}));
      
      connect(u1[1], Gain_Steer_Control1.C[1]) annotation (points=[-90,75; -42,
            75; -42,53.8; 9.7,53.8], style(color=74, rgbcolor={0,0,127}));
  end Standard_Driver;
    
  model Joystick_Driver 
      parameter Modelica.SIunits.Mass Upper_Body_Mass=43;
      parameter Modelica.SIunits.Mass Lower_Body_Mass=25.83;
      
    Modelica.Mechanics.MultiBody.Parts.Body Lower_Body(
      I_11=0.5,
      I_22=0.5,
      I_33=0.5,
      cylinderDiameter=0,
        m=Lower_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.F_dx,0,-Dimension_MassPosition_data.
            F_dy}) 
                annotation (extent=[-30,-54; -10,-34],
                                                     rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Upper_Body(
      I_11=1.428,
      I_22=1.347,
      I_33=0.916,
      I_31=0.433,
      cylinderDiameter=0,
        m=Upper_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.G_dx,0,Dimension_MassPosition_data.
            G_dy})              annotation (extent=[-30,4; -10,24],  rotation=
          90);
    annotation (Diagram, Icon);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Seaddle 
      annotation (extent=[-20,-100; 0,-80]);
    Modelica.Blocks.Interfaces.RealInput Sensor1[6] 
      annotation (extent=[-100,-20; -80,0]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steering 
      annotation (extent=[80,20; 100,40]);
      
    public 
      Steering_Control.Stabilizer_2 Stabilizer_2_1(k2=6 + 8*0, k3=0.5 + 4*0) 
                       annotation (extent=[16,22; 36,42]);
      Modelica.Mechanics.MultiBody.Joints.ActuatedRevolute actuatedRevolute(n={
            -1,0,0}) annotation (extent=[-30,-22; -10,-2], rotation=270);
      Modelica.Mechanics.Rotational.Position position 
        annotation (extent=[16,-24; 36,-4], rotation=180);
      inner parameter Base_Dimension_MassPosition_Data 
        Dimension_MassPosition_data annotation (extent=[80,80; 100,100]);
  equation 
    connect(frame_Seaddle, Lower_Body.frame_a) annotation (points=[-10,-90; -60,
            -90; -60,-24; -20,-24; -20,-34],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Sensor1, Stabilizer_2_1.Sensor) annotation (points=[-90,-10; -86,
            -10; -86,28; 17,28; 17,27.8], style(color=74, rgbcolor={0,0,127}));
      connect(Stabilizer_2_1.flange_steer, flange_steering) annotation (points=
            [35,23; 62.5,23; 62.5,30; 90,30], style(color=0, rgbcolor={0,0,0}));
      connect(Upper_Body.frame_a, actuatedRevolute.frame_a) annotation (points=[-20,4;
            -20,1; -20,-2; -20,-2], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(actuatedRevolute.frame_b, Lower_Body.frame_a) annotation (points=[-20,-22;
            -20,-25; -20,-25; -20,-28; -20,-34; -20,-34],           style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(actuatedRevolute.axis, position.flange_b) annotation (points=[-10,-12;
            4,-12; 4,-14; 16,-14],      style(color=0, rgbcolor={0,0,0}));
      connect(actuatedRevolute.bearing, position.bearing) annotation (points=[-10,-6;
            8,-6; 8,-4; 26,-4],         style(color=0, rgbcolor={0,0,0}));
      connect(Sensor1[6], position.phi_ref) annotation (points=[-90,-1.66667;
            -88,-1.66667; -88,-62; 76,-62; 76,-14; 38,-14], style(color=74,
            rgbcolor={0,0,127}));
  end Joystick_Driver;
    
  model Joystick_Driver_Real 
      parameter Modelica.SIunits.Mass Upper_Body_Mass=43;
      parameter Modelica.SIunits.Mass Lower_Body_Mass=25.83;
      parameter Base_Dimension_MassPosition_Data Dimension_MassPosition_data 
        annotation (extent=[80,80; 100,100]);
    Modelica.Mechanics.MultiBody.Parts.Body Lower_Body(
      I_11=0.5,
      I_22=0.5,
      I_33=0.5,
      cylinderDiameter=0,
        m=Lower_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.F_dx,0,-Dimension_MassPosition_data.
            F_dy}) 
                annotation (extent=[-30,-54; -10,-34],
                                                     rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Upper_Body(
      I_11=1.428,
      I_22=1.347,
      I_33=0.916,
      I_31=0.433,
      cylinderDiameter=0,
        m=Upper_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.G_dx,0,Dimension_MassPosition_data.
            G_dy})              annotation (extent=[-30,4; -10,24],  rotation=
          90);
    annotation (Diagram, Icon);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Seaddle 
      annotation (extent=[-20,-100; 0,-80]);
    Modelica.Blocks.Interfaces.RealInput Sensor1[6] 
      annotation (extent=[-100,-20; -80,0]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steering 
      annotation (extent=[80,20; 100,40]);
      
    public 
      Steering_Control.Stabilizer_2 Stabilizer_2_1(k2=6 + 8*0, k3=0.5 + 4*0) 
                       annotation (extent=[22,22; 42,42]);
    Modelica.Mechanics.MultiBody.Joints.ActuatedRevolute actuatedRevolute(n={-1,
            0,0}) 
              annotation (extent=[-30,-22; -10,-2], rotation=270);
    public 
      Steering_Control.Stabilizer_2_Real Stabilizer_2_2(
        k1=k1,
        k2=k2,
        k3=k3)         annotation (extent=[14,-32; 34,-12], rotation=180);
      parameter Real k1=150 "Roll Angle Feedback Coefficient";
      parameter Real k2=60 "Roll Angular Speed Feedback Coefficient";
      parameter Real k3=0 "Roll Angular Acceleration Feedback Coefficient";
      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor 
        annotation (extent=[2,-6; 22,14]);
  equation 
    connect(frame_Seaddle, Lower_Body.frame_a) annotation (points=[-10,-90; -60,
            -90; -60,-24; -20,-24; -20,-34],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Sensor1, Stabilizer_2_1.Sensor) annotation (points=[-90,-10; -86,
          -10; -86,28; 23,28; 23,27.8],   style(color=74, rgbcolor={0,0,127}));
      connect(Stabilizer_2_1.flange_steer, flange_steering) annotation (points=[41,23;
          62.5,23; 62.5,30; 90,30],           style(color=0, rgbcolor={0,0,0}));
    connect(Upper_Body.frame_a, actuatedRevolute.frame_a) annotation (points=[-20,4;
            -20,1; -20,-2; -20,-2],
                                  style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
    connect(actuatedRevolute.frame_b, Lower_Body.frame_a) annotation (points=[-20,-22;
            -20,-25; -20,-25; -20,-28; -20,-34; -20,-34],    style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
    connect(actuatedRevolute.axis, Stabilizer_2_2.flange_steer) annotation (
        points=[-10,-12; -3.5,-12; -3.5,-13; 15,-13], style(color=0, rgbcolor={0,
            0,0}));
      connect(actuatedRevolute.axis, angleSensor.flange_a) annotation (points=[-10,-12;
            2,-12; 2,4],          style(color=0, rgbcolor={0,0,0}));
      connect(angleSensor.phi, Stabilizer_2_2.Sensor) annotation (points=[23,4;
            76,4; 76,-17.8; 33,-17.8], style(color=74, rgbcolor={0,0,127}));
  end Joystick_Driver_Real;
    
  model Joystick_Driver_Real_GR 
      parameter Modelica.SIunits.Mass Upper_Body_Mass=43;
      parameter Modelica.SIunits.Mass Lower_Body_Mass=25.83;
      parameter Base_Dimension_MassPosition_Data Dimension_MassPosition_data 
        annotation (extent=[80,80; 100,100]);
      
    Modelica.Mechanics.MultiBody.Parts.Body Lower_Body(
      I_11=0.5,
      I_22=0.5,
      I_33=0.5,
      cylinderDiameter=0,
        m=Lower_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.F_dx,0,-Dimension_MassPosition_data.
            F_dy}) 
                annotation (extent=[-30,-54; -10,-34],
                                                     rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Upper_Body(
      I_11=1.428,
      I_22=1.347,
      I_33=0.916,
      I_31=0.433,
      cylinderDiameter=0,
        m=Upper_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.G_dx,0,Dimension_MassPosition_data.
            G_dy})              annotation (extent=[-30,4; -10,24],  rotation=
          90);
    annotation (Diagram, Icon);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Seaddle 
      annotation (extent=[-20,-100; 0,-80]);
    Modelica.Blocks.Interfaces.RealInput Sensor1[6] 
      annotation (extent=[-100,-20; -80,0]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steering 
      annotation (extent=[80,20; 100,40]);
      
    public 
      Steering_Control.Stabilizer_2 Stabilizer_2_1(k2=6 + 8*0, k3=0.5 + 4*0) 
                       annotation (extent=[22,22; 42,42]);
    Modelica.Mechanics.MultiBody.Joints.ActuatedRevolute actuatedRevolute(n={-1,
            0,0}) 
              annotation (extent=[-30,-22; -10,-2], rotation=270);
      parameter Real k1=150 "Roll Angle Feedback Coefficient";
      parameter Real k2=60 "Roll Angular Speed Feedback Coefficient";
      parameter Real k3=0 "Roll Angular Acceleration Feedback Coefficient";
      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor 
        annotation (extent=[2,-6; 22,14]);
    public 
      Steering_Control.Stabilizer_2 Stabilizer_2_2(
        k1=k1,
        k2=k2,
        k3=k3)         annotation (extent=[24,-32; 44,-12], rotation=180);
      Modelica.Mechanics.Rotational.Torque torque 
        annotation (extent=[18,-72; 38,-52], rotation=90);
      Modelica.Blocks.Math.Gain gain(k=k) annotation (extent=[-74,-90; -54,-70]);
      parameter Real k=0 "Gain value multiplied with input signal";
      Modelica.Blocks.Interfaces.RealOutput phi1 
        annotation (extent=[92,-6; 112,14]);
  equation 
    connect(frame_Seaddle, Lower_Body.frame_a) annotation (points=[-10,-90; -40,
            -90; -40,-24; -20,-24; -20,-34],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Sensor1, Stabilizer_2_1.Sensor) annotation (points=[-90,-10; -86,
          -10; -86,28; 23,28; 23,27.8],   style(color=74, rgbcolor={0,0,127}));
      connect(Stabilizer_2_1.flange_steer, flange_steering) annotation (points=[41,23;
          62.5,23; 62.5,30; 90,30],           style(color=0, rgbcolor={0,0,0}));
    connect(Upper_Body.frame_a, actuatedRevolute.frame_a) annotation (points=[-20,4;
            -20,1; -20,-2; -20,-2],
                                  style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
    connect(actuatedRevolute.frame_b, Lower_Body.frame_a) annotation (points=[-20,-22;
            -20,-25; -20,-25; -20,-28; -20,-34; -20,-34],    style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
      connect(actuatedRevolute.axis, angleSensor.flange_a) annotation (points=[-10,-12;
            2,-12; 2,4],          style(color=0, rgbcolor={0,0,0}));
      connect(actuatedRevolute.axis, Stabilizer_2_2.flange_steer) annotation (
          points=[-10,-12; -1,-12; -1,-13; 25,-13], style(color=0, rgbcolor={0,
              0,0}));
      connect(torque.flange_b, actuatedRevolute.axis) annotation (points=[28,-52;
            28,-40; 6,-40; 6,-20; -10,-20; -10,-12],      style(color=0,
            rgbcolor={0,0,0}));
      connect(gain.y, torque.tau) annotation (points=[-53,-80; 28,-80; 28,-74],
          style(color=74, rgbcolor={0,0,127}));
      connect(Sensor1[6], gain.u) annotation (points=[-90,-1.66667; -88,
            -1.66667; -88,-80; -76,-80], style(color=74, rgbcolor={0,0,127}));
      connect(angleSensor.phi, Stabilizer_2_2.Sensor[6]) annotation (points=[23,4; 88,
            4; 88,-18.6333; 43,-18.6333],    style(color=74, rgbcolor={0,0,127}));
      connect(angleSensor.phi, phi1) 
        annotation (points=[23,4; 102,4], style(color=74, rgbcolor={0,0,127}));
  end Joystick_Driver_Real_GR;
    
  model Joystick_Driver_2 
      parameter Modelica.SIunits.Mass Upper_Body_Mass=43;
      parameter Modelica.SIunits.Mass Lower_Body_Mass=25.83;
      
    Modelica.Mechanics.MultiBody.Parts.Body Lower_Body(
      I_11=0.5,
      I_22=0.5,
      I_33=0.5,
      cylinderDiameter=0,
        m=Lower_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.F_dx,0,-Dimension_MassPosition_data.
            F_dy}) 
                annotation (extent=[-30,-54; -10,-34],
                                                     rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Upper_Body(
      I_11=1.428,
      I_22=1.347,
      I_33=0.916,
      I_31=0.433,
      cylinderDiameter=0,
        m=Upper_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.G_dx,0,Dimension_MassPosition_data.
            G_dy})              annotation (extent=[-30,-12; -10,8], rotation=
          90);
    annotation (Diagram, Icon);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Seaddle 
      annotation (extent=[-20,-100; 0,-80]);
    Modelica.Blocks.Interfaces.RealInput Sensor1[6] 
      annotation (extent=[-100,-20; -80,0]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steering 
      annotation (extent=[80,20; 100,40]);
    protected 
      outer Base_Dimension_MassPosition_Data Dimension_MassPosition_data 
        annotation (extent=[80,80; 100,100]);
    public 
      Steering_Control.Stabilizer_2 Stabilizer(k1=k1, k3=k3) 
                                                annotation (extent=[18,2; 38,22]);
    parameter Real k1=100;
    parameter Real k3=4;
    Modelica.Blocks.Interfaces.RealInput Rider 
      annotation (extent=[-102,60; -82,80]);
      Modelica.Mechanics.Rotational.Torque Torque1 
        annotation (extent=[44,50; 64,70]);
      Modelica.Blocks.Math.Add Add1(k1=-1) annotation (extent=[-10,54; 10,74]);
      Modelica.Blocks.Continuous.Integrator Integrator1 
        annotation (extent=[-56,44; -36,64]);
  equation 
    connect(Lower_Body.frame_a, Upper_Body.frame_a) annotation (points=[-20,-34;
            -20,-23; -20,-12; -20,-12],
                   style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_Seaddle, Lower_Body.frame_a) annotation (points=[-10,-90; -60,
            -90; -60,-24; -20,-24; -20,-34],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Stabilizer.flange_steer, flange_steering)  annotation (points=[37,
            3; 72,3; 72,30; 90,30], style(color=0, rgbcolor={0,0,0}));
      connect(Sensor1, Stabilizer.Sensor)  annotation (points=[-90,-10; -78,-10;
            -78,-6; -64,-6; -64,18; 2,18; 2,7.8; 19,7.8], style(color=74,
            rgbcolor={0,0,127}));
      connect(Torque1.flange_b, flange_steering) annotation (points=[64,60; 90,
            60; 90,30], style(color=0, rgbcolor={0,0,0}));
      connect(Rider, Add1.u1) annotation (points=[-92,70; -12,70], style(color=
              74, rgbcolor={0,0,127}));
      connect(Add1.y, Torque1.tau) annotation (points=[11,64; 28,64; 28,60; 42,
            60], style(color=74, rgbcolor={0,0,127}));
      connect(Rider, Integrator1.u) annotation (points=[-92,70; -76,70; -76,54;
            -58,54], style(color=74, rgbcolor={0,0,127}));
      connect(Integrator1.y, Add1.u2) annotation (points=[-35,54; -24,54; -24,
            58; -12,58], style(color=74, rgbcolor={0,0,127}));
  end Joystick_Driver_2;
    
  model Roll_Driver 
      parameter Modelica.SIunits.Mass Upper_Body_Mass=43;
      parameter Modelica.SIunits.Mass Lower_Body_Mass=25.83;
      
    Modelica.Mechanics.MultiBody.Parts.Body Lower_Body(
      I_11=0.5,
      I_22=0.5,
      I_33=0.5,
      cylinderDiameter=0,
        m=Lower_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.F_dx,0,-Dimension_MassPosition_data.
            F_dy}) 
                annotation (extent=[-30,-54; -10,-34],
                                                     rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Upper_Body(
      I_11=1.428,
      I_22=1.347,
      I_33=0.916,
      I_31=0.433,
      cylinderDiameter=0,
        m=Upper_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.G_dx,0,Dimension_MassPosition_data.
            G_dy})              annotation (extent=[-30,-12; -10,8], rotation=
          90);
    annotation (Diagram, Icon);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Seaddle 
      annotation (extent=[-20,-100; 0,-80]);
    Modelica.Blocks.Interfaces.RealInput Sensors[6] 
      annotation (extent=[-100,-20; -80,0]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steering 
      annotation (extent=[80,20; 100,40]);
    protected 
      outer Base_Dimension_MassPosition_Data Dimension_MassPosition_data 
        annotation (extent=[80,80; 100,100], world(x_label(
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial,
        DymolaEmptyOuterSpecial)));
    public 
      Steering_Control.Roll_Steer_Control Roll_Steer_Control1(
        k1=k1,
        k2=k2,
        k3=k3,
        T=T) annotation (extent=[8,18; 28,38]);
      Modelica.Blocks.Interfaces.RealInput Roll_SP 
        annotation (extent=[-100,60; -80,80]);
      parameter Real k1=15.5;
      parameter Real k2=6;
      parameter Real k3=4;
      parameter Modelica.SIunits.Time T=8;
  equation 
    connect(Lower_Body.frame_a, Upper_Body.frame_a) annotation (points=[-20,-34;
            -20,-23; -20,-12; -20,-12],
                   style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_Seaddle, Lower_Body.frame_a) annotation (points=[-10,-90; -60,
            -90; -60,-24; -20,-24; -20,-34],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Sensors, Roll_Steer_Control1.Sensor) annotation (points=[-90,-10;
            -40,-10; -40,23.8; 9,23.8], style(color=74, rgbcolor={0,0,127}));
      connect(Roll_Steer_Control1.flange_steer, flange_steering) annotation (
          points=[27,19; 57.5,19; 57.5,30; 90,30], style(color=0, rgbcolor={0,0,
              0}));
      connect(Roll_Steer_Control1.Roll_SP, Roll_SP) annotation (points=[9,35;
            -40.5,35; -40.5,70; -90,70], style(color=74, rgbcolor={0,0,127}));
      
  end Roll_Driver;
    
  model Roll_Driver_GR 
      parameter Modelica.SIunits.Mass Upper_Body_Mass=43;
      parameter Modelica.SIunits.Mass Lower_Body_Mass=25.83;
      parameter Real k1=15.5;
      parameter Real k2=6;
      parameter Real k3=4;
    Modelica.Mechanics.MultiBody.Parts.Body Lower_Body(
      I_11=0.5,
      I_22=0.5,
      I_33=0.5,
      cylinderDiameter=0,
        m=Lower_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.F_dx,0,-Dimension_MassPosition_data.
            F_dy}) 
                annotation (extent=[-30,-80; -10,-60],
                                                     rotation=270);
    Modelica.Mechanics.MultiBody.Parts.Body Upper_Body(
      I_11=1.428,
      I_22=1.347,
      I_33=0.916,
      I_31=0.433,
      cylinderDiameter=0,
        m=Upper_Body_Mass,
        sphereDiameter=0.08,
        sphereColor={0,128,0},
        r_CM={Dimension_MassPosition_data.G_dx,0,Dimension_MassPosition_data.
            G_dy})              annotation (extent=[-30,-38; -10,-18],
                                                                     rotation=
          90);
    annotation (Diagram, Icon);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_Seaddle 
      annotation (extent=[-20,-100; 0,-80]);
    Modelica.Blocks.Interfaces.RealInput Sensors[6] 
      annotation (extent=[-100,-20; -80,0]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steering 
      annotation (extent=[80,20; 100,40]);
    Base_Dimension_MassPosition_Data Dimension_MassPosition_data;
    public 
      Modelica.Blocks.Interfaces.RealInput Roll_SP 
        annotation (extent=[-100,60; -80,80]);
    Steering_Control.Stabilizer_2 stabilizer_2_2(
      k1=k1,
      k2=k2,
      k3=k3) annotation (extent=[32,50; 52,70]);
      Modelica.Blocks.Math.Add add(k1=-1) annotation (extent=[-52,48; -32,68]);
  equation 
    connect(Lower_Body.frame_a, Upper_Body.frame_a) annotation (points=[-20,-60;
            -20,-49; -20,-49; -20,-38],
                   style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_Seaddle, Lower_Body.frame_a) annotation (points=[-10,-90; -60,
            -90; -60,-50; -20,-50; -20,-60],
                                           style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(flange_steering, stabilizer_2_2.flange_steer) annotation (points=[90,30;
            90,52; 51,52; 51,51],   style(color=0, rgbcolor={0,0,0}));
      connect(Roll_SP, add.u1) annotation (points=[-90,70; -72,70; -72,64; -54,
            64], style(color=74, rgbcolor={0,0,127}));
      connect(Sensors[6], add.u2) annotation (points=[-90,-1.66667; -74,
            -1.66667; -74,52; -54,52], style(color=74, rgbcolor={0,0,127}));
    connect(add.y, stabilizer_2_2.Sensor[6]) annotation (points=[-31,58; 0,58;
            0,56.6333; 33,56.6333],
                                style(color=74, rgbcolor={0,0,127}));
  end Roll_Driver_GR;
    
    package Steering_Control 
      
    model Gain_Steer_Control 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angular position Forward Coefficient";
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      parameter Real k4=0 "Lenght Error Coefficient";
      parameter Real k5=0 "Angle Speed Path Error Coeffiecient";
      parameter Real k6=-2;
      parameter Real tau1=0.01;
      parameter Real tau2=0.01;
      Real Vx2;
      Real roll;
      constant Real pi=Modelica.Constants.pi;
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Math.Atan Atan1 annotation (extent=[20,-28; 32,-16]);
      Modelica.Blocks.Math.Product Product1 annotation (extent=[-44,-36; -32,-24]);
      Modelica.Blocks.Math.Product Product2 annotation (extent=[-20,-36; -8,-24]);
      Modelica.Blocks.Math.Add ErrRoll[+1](
        each k1=
           -1,
        each k2=
           +1) annotation (extent=[46,-32; 58,-20]);
      Modelica.Blocks.Math.Gain Gain2(k=1/9.8066) 
        annotation (extent=[0,-32; 12,-20]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
      Modelica.Blocks.Interfaces.RealInput Signals[4] 
        annotation (extent=[-100,60; -80,80]);
      Modelica.Blocks.Math.Gain Curvature_sign(k=-1) 
        annotation (extent=[-50,-14; -34,-4]);
    //  Modelica.Blocks.Interfaces.OutPort outPort1 
    //    annotation (extent=[-33,-41; -31,-39]);
      public 
      Modelica.Blocks.Nonlinear.Limiter Limiter1(uMax=1000) 
        annotation (extent=[104,-58; 116,-46],  rotation=180);
      Modelica.Blocks.Continuous.TransferFunction TransferFunction1(b={k3,k2,k1},
          a={tau1*tau2,tau1 + tau2,1}) 
        annotation (extent=[100,-38; 120,-18],
                                             rotation=0);
      Modelica.Blocks.Math.Add ErrCurv[+1](
        each k1=
           -1,
        each k2=
           +1) annotation (extent=[18,4; 30,16]);
      Modelica.Blocks.Math.Add Err[+1](
        each k1=
           +1,
        each k2=
           +1) annotation (extent=[78,-34; 90,-22],
                                                  rotation=0);
      Modelica.Blocks.Continuous.PI PI1(T=2, k=k6) 
        annotation (extent=[44,0; 64,20]);
      Modelica.Blocks.Math.Gain tmp(k=-1) 
        annotation (extent=[130,-46; 140,-34],rotation=270);
    equation 
    Vx2=Product1.y;
    roll=Sensor[6];
    ErrCurv[1].u2=-tan(roll)*9.8066/(Vx2+1e-6)*(atan(10^3*(Vx2-5))+pi/2)/pi;
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
      connect(Gain2.y, Atan1.u) annotation (points=[12.6,-26; 14,-26; 14,-22;
                18.8,-22],
                  style(color=74, rgbcolor={0,0,127}));
        
      connect(Product2.y, Gain2.u) annotation (points=[-7.4,-30; -4,-30; -4,-26;
              -1.2,-26],
                       style(color=74, rgbcolor={0,0,127}));
      connect(ErrCurv[1].y, PI1.u) annotation (points=[30.6,10; 42,10],
                  style(color=74, rgbcolor={0,0,127}));
      connect(TransferFunction1.y, tmp.u) annotation (points=[121,-28; 135,-28;
            135,-32.8],
                    style(color=74, rgbcolor={0,0,127}));
      connect(Limiter1.u, tmp.y) annotation (points=[117.2,-52; 135,-52; 135,
                -46.6],
          style(color=74, rgbcolor={0,0,127}));
      connect(Limiter1.y, Torque1.tau) annotation (points=[103.4,-52; 94,-52; 94,
                -62.6],
                    style(color=74, rgbcolor={0,0,127}));
      connect(Err[1].y, TransferFunction1.u) annotation (points=[90.6,-28; 98,-28],
          style(color=74, rgbcolor={0,0,127}));
      connect(Atan1.y, ErrRoll[1].u1) annotation (points=[32.6,-22; 37.7,-22;
                37.7,-22.4; 44.8,-22.4],
                                     style(color=74, rgbcolor={0,0,127}));
      connect(ErrRoll[1].y, Err[1].u2) annotation (points=[58.6,-26; 68,-26; 68,
            -31.6; 76.8,-31.6], style(color=74, rgbcolor={0,0,127}));
      connect(PI1.y, Err[1].u1) annotation (points=[65,10; 72,10; 72,-24.4; 76.8,
            -24.4], style(color=74, rgbcolor={0,0,127}));
      connect(Signals[2], ErrCurv[1].u1) annotation (points=[-90,67.5; -38,67.5;
            -38,13.6; 16.8,13.6], style(color=74, rgbcolor={0,0,127}));
      connect(Sensor[4], Product1.u1) annotation (points=[-90,-40.3333; -74,
              -40.3333; -74,-26.4; -45.2,-26.4],
                                               style(color=74, rgbcolor={0,0,127}));
      connect(Sensor[4], Product1.u2) annotation (points=[-90,-40.3333; -72,
              -40.3333; -72,-33.6; -45.2,-33.6],
                                               style(color=74, rgbcolor={0,0,127}));
      connect(Curvature_sign.y, Product2.u1) annotation (points=[-33.2,-9; -26,-9;
                -26,-26.4; -21.2,-26.4],  style(color=74, rgbcolor={0,0,127}));
      connect(Product1.y, Product2.u2) annotation (points=[-31.4,-30; -26,-30;
            -26,-33.6; -21.2,-33.6], style(color=74, rgbcolor={0,0,127}));
      connect(Sensor[6], ErrRoll[1].u2) annotation (points=[-90,-33.6667; -78,
              -33.6667; -78,-50; 36,-50; 36,-29.6; 44.8,-29.6],
                                                              style(color=74,
            rgbcolor={0,0,127}));
      connect(Signals[1], Curvature_sign.u) annotation (points=[-90,62.5; -64,
                62.5; -64,-9; -51.6,-9],
                                       style(color=74, rgbcolor={0,0,127}));
    end Gain_Steer_Control;
      
    model Gain_Steer_Control_2 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angular position Forward Coefficient";
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      parameter Real k4=0 "Lenght Error Coefficient";
      parameter Real k5=0 "Angle Speed Path Error Coeffiecient";
      parameter Real k6=-2;
      parameter Real tau1=0.01;
      parameter Real tau2=0.01;
      Real Vx2;
      Real roll;
      constant Real pi=Modelica.Constants.pi;
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
      Modelica.Blocks.Interfaces.RealInput Signals[4] 
        annotation (extent=[-100,60; -80,80]);
    //  Modelica.Blocks.Interfaces.OutPort outPort1 
    //    annotation (extent=[-33,-41; -31,-39]);
      public 
      Modelica.Blocks.Nonlinear.Limiter Limiter1(uMax=1000) 
        annotation (extent=[104,-58; 116,-46],  rotation=180);
      Modelica.Blocks.Math.Gain tmp(k=1) 
        annotation (extent=[130,-46; 140,-34],rotation=270);
          Modelica.Blocks.Continuous.Derivative Derivative1 
            annotation (extent=[-4,-6; 6,4]);
          Modelica.Blocks.Math.Add3 Add3_1 annotation (extent=[74,-24; 94,-4]);
      Modelica.Blocks.Math.Gain K1(k=30) 
        annotation (extent=[50,-2; 60,10],    rotation=0);
      Modelica.Blocks.Math.Gain K2(k=20) 
        annotation (extent=[50,-20; 60,-8],   rotation=0);
      Modelica.Blocks.Math.Gain K3(k=10) 
        annotation (extent=[48,-38; 58,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Derivative2 
            annotation (extent=[18,-36; 28,-26]);
          Modelica.Blocks.Math.Add ErrCurv(k1=-1, k2=+1) 
            annotation (extent=[-10,44; 10,64]);
    equation 
    Vx2=Sensor[4]^2;
    roll=Sensor[6];
    ErrCurv.u2=-tan(roll)*9.8066/(Vx2+1e-6)*(atan(10^3*(Vx2-5))+pi/2)/pi;
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
      connect(Limiter1.u, tmp.y) annotation (points=[117.2,-52; 135,-52; 135,
                -46.6],
          style(color=74, rgbcolor={0,0,127}));
      connect(Limiter1.y, Torque1.tau) annotation (points=[103.4,-52; 94,-52; 94,
                -62.6],
                    style(color=74, rgbcolor={0,0,127}));
          connect(K1.y, Add3_1.u1) annotation (points=[60.5,4; 66,4; 66,-6; 72,-6],
              style(color=74, rgbcolor={0,0,127}));
          connect(K2.y, Add3_1.u2) annotation (points=[60.5,-14; 72,-14], style(
                color=74, rgbcolor={0,0,127}));
          connect(K3.y, Add3_1.u3) annotation (points=[58.5,-32; 66,-32; 66,-22;
                72,-22], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative2.y, K3.u) annotation (points=[28.5,-31; 37.25,-31;
                37.25,-32; 47,-32], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, K2.u) annotation (points=[6.5,-1; 28.25,-1;
                28.25,-14; 49,-14], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, Derivative2.u) annotation (points=[6.5,-1; 6.5,
                -30.5; 17,-30.5; 17,-31], style(color=74, rgbcolor={0,0,127}));
          connect(ErrCurv.y, K1.u) annotation (points=[11,54; 38,54; 38,4; 49,4],
              style(color=74, rgbcolor={0,0,127}));
          connect(ErrCurv.y, Derivative1.u) annotation (points=[11,54; 26,54; 26,
                10; -16,10; -16,-1; -5,-1], style(color=74, rgbcolor={0,0,127}));
          connect(Signals[1], ErrCurv.u1) annotation (points=[-90,62.5; -52,62.5;
                -52,60; -12,60], style(color=74, rgbcolor={0,0,127}));
        
          connect(Add3_1.y, tmp.u) annotation (points=[95,-14; 135,-14; 135,-32.8],
              style(color=74, rgbcolor={0,0,127}));
    end Gain_Steer_Control_2;
      
    model Gain_Steer_Control_3 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angular position Forward Coefficient";
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      parameter Real k4=0 "Lenght Error Coefficient";
      parameter Real k5=0 "Angle Speed Path Error Coeffiecient";
      parameter Real k6=-2;
      parameter Real tau1=0.01;
      parameter Real tau2=0.01;
      Real Vx2;
      Real roll;
      constant Real pi=Modelica.Constants.pi;
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
      Modelica.Blocks.Interfaces.RealInput Signals[4] 
        annotation (extent=[-100,60; -80,80]);
    //  Modelica.Blocks.Interfaces.OutPort outPort1 
    //    annotation (extent=[-33,-41; -31,-39]);
          Modelica.Blocks.Continuous.PID PID1(
            Td=0.001,
            k=25,
            Nd=1000,
            Ti=14)   annotation (extent=[20,0; 40,20]);
          Modelica.Blocks.Math.Add Add(k1=+1, k2=-1) 
            annotation (extent=[-42,0; -22,20]);
    equation 
    Vx2=Sensor[4]^2;
    roll=Sensor[6];
    Add.u2=tan(roll)*9.8066/(Vx2+1e-6)*(atan(10^3*(Vx2-5))+pi/2)/pi;
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
          connect(Add.y, PID1.u) annotation (points=[-21,10; 18,10],
                                                                   style(color=74,
                rgbcolor={0,0,127}));
        
          connect(Signals[1], Add.u1) annotation (points=[-90,62.5; -54,62.5; -54,
                16; -44,16], style(color=74, rgbcolor={0,0,127}));
          connect(PID1.y, Torque1.tau) annotation (points=[41,10; 94,10; 94,-62.6],
              style(color=74, rgbcolor={0,0,127}));
    end Gain_Steer_Control_3;
      
    model Gain_Steer_Control_4 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angular position Forward Coefficient";
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      parameter Real k4=0 "Lenght Error Coefficient";
      parameter Real k5=0 "Angle Speed Path Error Coeffiecient";
      parameter Real k6=-2;
      parameter Real tau1=0.01;
      parameter Real tau2=0.01;
      Real Vx2;
      Real roll;
      Real C_stim;
      constant Real pi=Modelica.Constants.pi;
        
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
      Modelica.Blocks.Interfaces.RealInput Signals[4] 
        annotation (extent=[-100,60; -80,80]);
    //  Modelica.Blocks.Interfaces.OutPort outPort1 
    //    annotation (extent=[-33,-41; -31,-39]);
          Modelica.Blocks.Math.Add Add1(k2=-1) annotation (extent=[42,0; 62,20]);
          Modelica.Blocks.Continuous.Derivative Derivative1 
            annotation (extent=[30,48; 50,68]);
          Modelica.Blocks.Continuous.Derivative Derivative2 
            annotation (extent=[-6,-26; 14,-6]);
          Modelica.Blocks.Continuous.PI PI1(T=0.1, k=0.4*40) 
            annotation (extent=[70,0; 90,20]);
          Modelica.Blocks.Continuous.PI PI2(T=4, k=18) 
            annotation (extent=[0,48; 20,68]);
          Modelica.Blocks.Math.Add Add2(k1=+0.5) 
            annotation (extent=[-28,48; -8,68]);
          Modelica.Blocks.Math.Add Add3(k2=-1) 
            annotation (extent=[-50,74; -30,94]);
        
          Modelica.Blocks.Continuous.Derivative Derivative3 
            annotation (extent=[-100,20; -80,40]);
        Modelica.Blocks.Math.Add3 Add(k2=-1, k3=-0.05) 
          annotation (extent=[-66,32; -46,52]);
    equation 
      C_stim=tan(roll)*9.8066/(Vx2+1e-6)*(atan(10^3*(Vx2-5))+pi/2)/pi;
      Vx2=Sensor[4]^2;
      roll=Sensor[6];
      Add.u2=C_stim;
      Derivative2.u=C_stim;
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
          connect(Derivative2.y, Add1.u2) annotation (points=[15,-16; 20,-16; 20,
                4; 40,4],                style(color=74, rgbcolor={0,0,127}));
          connect(Add1.y, PI1.u) annotation (points=[63,10; 68,10], style(color=
                  74, rgbcolor={0,0,127}));
          connect(PI2.y, Derivative1.u) annotation (points=[21,58; 28,58], style(
                color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, Add1.u1) annotation (points=[51,58; 58,58; 58,30;
                28,30; 28,16; 40,16], style(color=74, rgbcolor={0,0,127}));
          connect(Add2.y, PI2.u) annotation (points=[-7,58; -2,58], style(color=
                  74, rgbcolor={0,0,127}));
          connect(Add3.y, Add2.u1) annotation (points=[-29,84; -26,84; -26,70;
                -36,70; -36,64; -30,64], style(color=74, rgbcolor={0,0,127}));
          connect(Signals[1], Add3.u2) annotation (points=[-90,62.5; -72,62.5;
                -72,78; -52,78], style(color=74, rgbcolor={0,0,127}));
          connect(Signals[2], Add3.u1) annotation (points=[-90,67.5; -76,67.5;
                -76,90; -52,90], style(color=74, rgbcolor={0,0,127}));
        connect(PI1.y, Torque1.tau) annotation (points=[91,10; 94,10; 94,-62.6],
                                           style(color=74, rgbcolor={0,0,127}));
        connect(Add.y, Add2.u2) annotation (points=[-45,42; -40,42; -40,52; -30,
              52], style(color=74, rgbcolor={0,0,127}));
        connect(Signals[1], Add.u1) annotation (points=[-90,62.5; -80,62.5; -80,
              50; -68,50], style(color=74, rgbcolor={0,0,127}));
        connect(Sensor[6], Derivative3.u) annotation (points=[-90,-33.6667; -90,
              -10; -162,-10; -162,30; -102,30], style(color=74, rgbcolor={0,0,
                127}));
        connect(Derivative3.y, Add.u3) annotation (points=[-79,30; -76,30; -76,
              34; -68,34], style(color=74, rgbcolor={0,0,127}));
        
    end Gain_Steer_Control_4;
      
    model Gain_Steer_Control_Marescotti 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angular position Forward Coefficient";
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      parameter Real k4=0 "Lenght Error Coefficient";
      parameter Real k5=0 "Angle Speed Path Error Coeffiecient";
        
      Real Vx2;
      Real roll;
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
      Modelica.Blocks.Interfaces.RealInput C[1] 
        annotation (extent=[-100,60; -80,80]);
    //  Modelica.Blocks.Interfaces.OutPort outPort1
    //    annotation (extent=[-33,-41; -31,-39]);
      Modelica.Blocks.Math.Gain tmp(k=1) 
        annotation (extent=[130,-46; 140,-34],rotation=270);
          Modelica.Blocks.Continuous.Derivative Derivative1 
            annotation (extent=[-4,-6; 6,4]);
          Modelica.Blocks.Math.Add3 Add3_1(k2=-1, k3=-1) 
                                           annotation (extent=[74,-24; 94,-4]);
      Modelica.Blocks.Math.Gain K1(k=k1) 
        annotation (extent=[50,-2; 60,10],    rotation=0);
      Modelica.Blocks.Math.Gain K2(k=k2) 
        annotation (extent=[50,-20; 60,-8],   rotation=0);
      Modelica.Blocks.Math.Gain K3(k=k3) 
        annotation (extent=[48,-38; 58,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Derivative2 
            annotation (extent=[18,-36; 28,-26]);
    equation 
    Vx2=Sensor[4]^2;
    roll=Sensor[6];
    K1.u=atan(Vx2*C[1]/9.8066)-roll;
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
          connect(K1.y, Add3_1.u1) annotation (points=[60.5,4; 66,4; 66,-6; 72,-6],
              style(color=74, rgbcolor={0,0,127}));
          connect(K2.y, Add3_1.u2) annotation (points=[60.5,-14; 72,-14], style(
                color=74, rgbcolor={0,0,127}));
          connect(K3.y, Add3_1.u3) annotation (points=[58.5,-32; 66,-32; 66,-22;
                72,-22], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative2.y, K3.u) annotation (points=[28.5,-31; 37.25,-31;
                37.25,-32; 47,-32], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, K2.u) annotation (points=[6.5,-1; 28.25,-1;
                28.25,-14; 49,-14], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, Derivative2.u) annotation (points=[6.5,-1; 6.5,
                -30.5; 17,-30.5; 17,-31], style(color=74, rgbcolor={0,0,127}));
          connect(Add3_1.y, tmp.u) annotation (points=[95,-14; 135,-14; 135,-32.8],
              style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[6], Derivative1.u) annotation (points=[-90,-33.6667; -48,
              -33.6667; -48,-1; -5,-1],   style(color=74, rgbcolor={0,0,127}));
          connect(Torque1.tau, tmp.y) annotation (points=[94,-62.6; 116,-62.6;
                116,-46.6; 135,-46.6], style(color=74, rgbcolor={0,0,127}));
    end Gain_Steer_Control_Marescotti;
      
    model Gain_Steer_Control_Marescotti_C 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angular position Forward Coefficient";
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      parameter Real k4=0 "Lenght Error Coefficient";
      parameter Real k5=0 "Angle Speed Path Error Coeffiecient";
      parameter Real k6=-2;
      parameter Real tau1=0.01;
      parameter Real tau2=0.01;
      Real Vx2;
      Real roll;
      constant Real pi=Modelica.Constants.pi;
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
      Modelica.Blocks.Interfaces.RealInput Signals[4] 
        annotation (extent=[-100,60; -80,80]);
    //  Modelica.Blocks.Interfaces.OutPort outPort1 
    //    annotation (extent=[-33,-41; -31,-39]);
      Modelica.Blocks.Math.Gain tmp(k=1) 
        annotation (extent=[130,-46; 140,-34],rotation=270);
          Modelica.Blocks.Continuous.Derivative Derivative1 
            annotation (extent=[-4,-6; 6,4]);
          Modelica.Blocks.Math.Add3 Add3_1 annotation (extent=[74,-24; 94,-4]);
      Modelica.Blocks.Math.Gain K1(k=30) 
        annotation (extent=[50,-2; 60,10],    rotation=0);
      Modelica.Blocks.Math.Gain K2(k=20) 
        annotation (extent=[50,-20; 60,-8],   rotation=0);
      Modelica.Blocks.Math.Gain K3(k=10) 
        annotation (extent=[48,-38; 58,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Derivative2 
            annotation (extent=[18,-36; 28,-26]);
          Modelica.Blocks.Math.Add ErrCurv(k1=-1, k2=+1) 
            annotation (extent=[-10,44; 10,64]);
    equation 
    Vx2=Sensor[4]^2;
    roll=Sensor[6];
    ErrCurv.u2=-tan(roll)*9.8066/(Vx2+1e-6)*(atan(10^3*(Vx2-5))+pi/2)/pi;
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
          connect(K1.y, Add3_1.u1) annotation (points=[60.5,4; 66,4; 66,-6; 72,-6],
              style(color=74, rgbcolor={0,0,127}));
          connect(K2.y, Add3_1.u2) annotation (points=[60.5,-14; 72,-14], style(
                color=74, rgbcolor={0,0,127}));
          connect(K3.y, Add3_1.u3) annotation (points=[58.5,-32; 66,-32; 66,-22;
                72,-22], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative2.y, K3.u) annotation (points=[28.5,-31; 37.25,-31;
                37.25,-32; 47,-32], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, K2.u) annotation (points=[6.5,-1; 28.25,-1;
                28.25,-14; 49,-14], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, Derivative2.u) annotation (points=[6.5,-1; 6.5,
                -30.5; 17,-30.5; 17,-31], style(color=74, rgbcolor={0,0,127}));
          connect(ErrCurv.y, K1.u) annotation (points=[11,54; 38,54; 38,4; 49,4],
              style(color=74, rgbcolor={0,0,127}));
          connect(Signals[1], ErrCurv.u1) annotation (points=[-90,62.5; -52,62.5;
                -52,60; -12,60], style(color=74, rgbcolor={0,0,127}));
        
          connect(Add3_1.y, tmp.u) annotation (points=[95,-14; 135,-14; 135,-32.8],
              style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[6], Derivative1.u) annotation (points=[-90,-33.6667; -48,
              -33.6667; -48,-1; -5,-1],   style(color=74, rgbcolor={0,0,127}));
          connect(Torque1.tau, tmp.y) annotation (points=[94,-62.6; 116,-62.6;
                116,-46.6; 135,-46.6], style(color=74, rgbcolor={0,0,127}));
    end Gain_Steer_Control_Marescotti_C;
      
    model Roll_Steer_Control 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angular position Forward Coefficient";
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      parameter Real k4=0 "Lenght Error Coefficient";
      parameter Real k5=0 "Angle Speed Path Error Coeffiecient";
      parameter Modelica.SIunits.Time T=8;
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
      Modelica.Blocks.Math.Gain tmp(k=1) 
        annotation (extent=[130,-46; 140,-34],rotation=270);
          Modelica.Blocks.Continuous.Derivative Derivative1 
            annotation (extent=[-4,-6; 6,4]);
          Modelica.Blocks.Math.Add3 Add3_1(k2=-1, k3=-1) 
                                           annotation (extent=[74,-24; 94,-4]);
      Modelica.Blocks.Math.Gain K2(k=k2) 
        annotation (extent=[50,-20; 60,-8],   rotation=0);
      Modelica.Blocks.Math.Gain K3(k=k3) 
        annotation (extent=[48,-38; 58,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Derivative2 
            annotation (extent=[18,-36; 28,-26]);
        Modelica.Blocks.Math.Add Add1(k2=-1) annotation (extent=[-22,18; -2,38]);
        Modelica.Blocks.Interfaces.RealInput Roll_SP 
          annotation (extent=[-100,60; -80,80]);
        Modelica.Blocks.Continuous.PI PI1(k=k1, T=T) 
          annotation (extent=[34,12; 54,32]);
        Modelica.Blocks.Math.Product coeff annotation (extent=[6,12; 26,32]);
      Modelica.Blocks.Tables.CombiTable1D Vx_Coeff(smoothness=Modelica.Blocks.Types.
            Smoothness.ContinuousDerivative, table=[0,0.9; 2.5,1; 5,1.2; 8,2; 10,8;
            20,25; 30,30; 40,35]) annotation (extent=[-20,60; 0,80]);
    equation 
    coeff.u2=exp(Sensor[6]^2)*Vx_Coeff.y[1];
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
          connect(K2.y, Add3_1.u2) annotation (points=[60.5,-14; 72,-14], style(
                color=74, rgbcolor={0,0,127}));
          connect(K3.y, Add3_1.u3) annotation (points=[58.5,-32; 66,-32; 66,-22;
                72,-22], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative2.y, K3.u) annotation (points=[28.5,-31; 37.25,-31;
                37.25,-32; 47,-32], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, K2.u) annotation (points=[6.5,-1; 28.25,-1;
                28.25,-14; 49,-14], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, Derivative2.u) annotation (points=[6.5,-1; 6.5,
                -30.5; 17,-30.5; 17,-31], style(color=74, rgbcolor={0,0,127}));
          connect(Add3_1.y, tmp.u) annotation (points=[95,-14; 135,-14; 135,-32.8],
              style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[6], Derivative1.u) annotation (points=[-90,-33.6667; -48,
              -33.6667; -48,-1; -5,-1],   style(color=74, rgbcolor={0,0,127}));
          connect(Torque1.tau, tmp.y) annotation (points=[94,-62.6; 116,-62.6;
                116,-46.6; 135,-46.6], style(color=74, rgbcolor={0,0,127}));
        connect(Sensor[6], Add1.u2) annotation (points=[-90,-33.6667; -54,-33.6667;
              -54,22; -24,22], style(color=74, rgbcolor={0,0,127}));
        connect(PI1.y, Add3_1.u1) annotation (points=[55,22; 58,22; 58,-6; 72,
              -6], style(color=74, rgbcolor={0,0,127}));
        connect(Add1.y, coeff.u1) annotation (points=[-1,28; 4,28], style(color=
               74, rgbcolor={0,0,127}));
        connect(coeff.y, PI1.u) annotation (points=[27,22; 28,22; 28,20; 30,20;
              30,22; 32,22], style(color=74, rgbcolor={0,0,127}));
        connect(Roll_SP, Add1.u1) annotation (points=[-90,70; -58,70; -58,34;
              -24,34], style(color=74, rgbcolor={0,0,127}));
      connect(Sensor[4], Vx_Coeff.u[1]) annotation (points=[-90,-40.3333; -70,
              -40.3333; -70,46; -52,46; -52,70; -22,70],
                                                       style(color=74, rgbcolor={0,
              0,127}));
        
    end Roll_Steer_Control;
      
    model Path_Table_Matrix "Table look-up in one dimension (matrix/file)" 
        import Modelica.Math.*;
        import Modelica.Mechanics.MultiBody.Frames.*;
        
      public 
      Modelica.Blocks.Interfaces.RealOutput toSteerControl[2] 
          "C, position error, angle error" 
                                         annotation (extent=[80, -20; 100, 0]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,20; -80,40]);
        
      Modelica.Blocks.Tables.CombiTable2D TableTeta(                      fileName=
           fileName,
        table=[0,0,1; 0,0,1; 1,1,1],
        tableName="teta",
        tableOnFile=("teta") <> "NoName") 
        annotation (extent=[0,36; 20,56]);
      Modelica.Blocks.Tables.CombiTable2D TablePath(                    fileName=
            fileName,
        table=[0,0,1; 0,0,1; 1,1,1],
        tableName="dist",
        tableOnFile=("dist") <> "NoName") 
        annotation (extent=[0,-36; 20,-16]);
      parameter String fileName="NoName";
    equation 
        
      annotation (Diagram);
          connect(TablePath.y, toSteerControl[1]) annotation (points=[21,-26; 50,
                -26; 50,-15; 90,-15], style(color=74, rgbcolor={0,0,127}));
          connect(TableTeta.y, toSteerControl[2]) annotation (points=[21,46; 52,
                46; 52,-5; 90,-5], style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[1], TablePath.u1) annotation (points=[-90,21.6667; -50,
              21.6667; -50,-20; -2,-20],   style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[1], TableTeta.u1) annotation (points=[-90,21.6667; -50,
              21.6667; -50,52; -2,52],   style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[2], TablePath.u2) annotation (points=[-90,25; -50,25;
                -50,-32; -2,-32], style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[2], TableTeta.u2) annotation (points=[-90,25; -50,25;
                -50,40; -2,40], style(color=74, rgbcolor={0,0,127}));
    end Path_Table_Matrix;
      
    model Stabilizer 
        import Modelica.Math.*;
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
          Modelica.Blocks.Continuous.Derivative Der1 
            annotation (extent=[-22,-36; -12,-26]);
      Modelica.Blocks.Math.Gain K3(k=k3) 
        annotation (extent=[52,-38; 62,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Der2 
            annotation (extent=[20,-36; 30,-26]);
      Modelica.Blocks.Math.Gain K1(k=k1) 
        annotation (extent=[48,6; 58,18],     rotation=0);
        parameter Real k1=1;
        Modelica.Blocks.Math.Add Add1(k1=-1, k2=-1) 
          annotation (extent=[68,-20; 88,0]);
    equation 
        
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
        connect(Der1.y, Der2.u)                 annotation (points=[-11.5,-31;
              -11.5,-30.5; 19,-30.5; 19,-31],
                                          style(color=74, rgbcolor={0,0,127}));
        connect(Sensor[6], Der1.u)          annotation (points=[-90,-33.6667; -48,
              -33.6667; -48,-31; -23,-31],style(color=74, rgbcolor={0,0,127}));
    //K3.u = if (abs(Der2.y)<0.01) then 0 else Der2.y;
        
        connect(Der2.y, K3.u) annotation (points=[30.5,-31; 41.25,-31; 41.25,
              -32; 51,-32], style(color=74, rgbcolor={0,0,127}));
        connect(Sensor[6], K1.u) annotation (points=[-90,-33.6667; -90,28; 28,28;
              28,12; 47,12],     style(color=74, rgbcolor={0,0,127}));
        connect(K1.y, Add1.u1) annotation (points=[58.5,12; 62,12; 62,-4; 66,-4],
            style(color=74, rgbcolor={0,0,127}));
        connect(K3.y, Add1.u2) annotation (points=[62.5,-32; 66,-32; 66,-16],
            style(color=74, rgbcolor={0,0,127}));
        connect(Add1.y, Torque1.tau) annotation (points=[89,-10; 92,-10; 92,
              -62.6; 94,-62.6], style(color=74, rgbcolor={0,0,127}));
    end Stabilizer;
      
    model Stabilizer_2 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angle Feedback Coefficient";
      parameter Real k2=6 "Roll Angular Speed Feedback Coefficient";
      parameter Real k3=0.5 "Roll Angular Acceleration Feedback Coefficient";
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
          Modelica.Blocks.Continuous.Derivative Derivative1 
            annotation (extent=[-40,-36; -30,-26]);
      Modelica.Blocks.Math.Gain K1(k=k1) 
        annotation (extent=[-12,18; -2,30],   rotation=0);
      Modelica.Blocks.Math.Gain K3(k=k3) 
        annotation (extent=[18,-38; 28,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Derivative2 
            annotation (extent=[-12,-36; -2,-26]);
        Modelica.Blocks.Math.Add3 Add3_1(
          k1=-1,
          k2=-1,
          k3=-1) annotation (extent=[68,-36; 88,-16]);
      Modelica.Blocks.Math.Gain K2(k=k2) 
        annotation (extent=[14,-12; 24,0],    rotation=0);
      annotation (Diagram);
    equation 
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
          connect(Derivative2.y, K3.u) annotation (points=[-1.5,-31; 7.25,-31;
              7.25,-32; 17,-32],    style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, Derivative2.u) annotation (points=[-29.5,-31;
              -29.5,-30.5; -13,-30.5; -13,-31],
                                          style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[6], Derivative1.u) annotation (points=[-90,-33.6667; -48,
              -33.6667; -48,-31; -41,-31],style(color=74, rgbcolor={0,0,127}));
      connect(Sensor[6], K1.u)   annotation (points=[-90,-33.6667; -68,-33.6667;
              -68,24; -13,24],        style(color=74, rgbcolor={0,0,127}));
        connect(Derivative1.y,K2. u) annotation (points=[-29.5,-31; -29.5,-6; 13,
              -6], style(color=74, rgbcolor={0,0,127}));
        connect(K3.y, Add3_1.u3) annotation (points=[28.5,-32; 46,-32; 46,-34;
              66,-34], style(color=74, rgbcolor={0,0,127}));
        connect(K2.y, Add3_1.u2) annotation (points=[24.5,-6; 44,-6; 44,-26; 66,
              -26], style(color=74, rgbcolor={0,0,127}));
      connect(K1.y, Add3_1.u1)    annotation (points=[-1.5,24; 52,24; 52,-18;
              66,-18], style(color=74, rgbcolor={0,0,127}));
        connect(Add3_1.y, Torque1.tau) annotation (points=[89,-26; 94,-26; 94,
              -62.6], style(color=74, rgbcolor={0,0,127}));
    end Stabilizer_2;
      
    model Stabilizer_2_Real 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angle Feedback Coefficient";
      parameter Real k2=6 "Roll Angular Speed Feedback Coefficient";
      parameter Real k3=0.5 "Roll Angular Acceleration Feedback Coefficient";
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor 
        annotation (extent=[-100,-52; -80,-32]);
          Modelica.Blocks.Continuous.Derivative Derivative1 
            annotation (extent=[-40,-36; -30,-26]);
      Modelica.Blocks.Math.Gain K1(k=k1) 
        annotation (extent=[-12,18; -2,30],   rotation=0);
      Modelica.Blocks.Math.Gain K3(k=k3) 
        annotation (extent=[18,-38; 28,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Derivative2 
            annotation (extent=[-12,-36; -2,-26]);
        Modelica.Blocks.Math.Add3 Add3_1(
          k1=-1,
          k2=-1,
          k3=-1) annotation (extent=[68,-36; 88,-16]);
      Modelica.Blocks.Math.Gain K2(k=k2) 
        annotation (extent=[14,-12; 24,0],    rotation=0);
      annotation (Diagram);
    equation 
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
          connect(Derivative2.y, K3.u) annotation (points=[-1.5,-31; 7.25,-31;
              7.25,-32; 17,-32],    style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, Derivative2.u) annotation (points=[-29.5,-31;
              -29.5,-30.5; -13,-30.5; -13,-31],
                                          style(color=74, rgbcolor={0,0,127}));
        connect(Derivative1.y,K2. u) annotation (points=[-29.5,-31; -29.5,-6; 13,
              -6], style(color=74, rgbcolor={0,0,127}));
        connect(K3.y, Add3_1.u3) annotation (points=[28.5,-32; 46,-32; 46,-34;
              66,-34], style(color=74, rgbcolor={0,0,127}));
        connect(K2.y, Add3_1.u2) annotation (points=[24.5,-6; 44,-6; 44,-26; 66,
              -26], style(color=74, rgbcolor={0,0,127}));
      connect(K1.y, Add3_1.u1)    annotation (points=[-1.5,24; 52,24; 52,-18;
              66,-18], style(color=74, rgbcolor={0,0,127}));
        connect(Add3_1.y, Torque1.tau) annotation (points=[89,-26; 94,-26; 94,
              -62.6], style(color=74, rgbcolor={0,0,127}));
        connect(Sensor, Derivative1.u) annotation (points=[-90,-42; -54,-42;
              -54,-31; -41,-31], style(color=74, rgbcolor={0,0,127}));
        connect(Sensor, K1.u) annotation (points=[-90,-42; -54,-42; -54,24; -13,
              24], style(color=74, rgbcolor={0,0,127}));
    end Stabilizer_2_Real;
      
    model Stabilizer_3 
        import Modelica.Math.*;
      parameter Real k1=15.5 "Roll Angular position Forward Coefficient";
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      parameter Real k4=0 "Lenght Error Coefficient";
      parameter Real k5=0 "Angle Speed Path Error Coeffiecient";
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
      Modelica.Blocks.Math.Gain tmp(k=1) 
        annotation (extent=[130,-46; 140,-34],rotation=270);
          Modelica.Blocks.Continuous.Derivative Derivative1 
            annotation (extent=[-4,-6; 6,4]);
          Modelica.Blocks.Math.Add3 Add3_1(k2=-1, k3=-1,
          k1=-1)                           annotation (extent=[74,-24; 94,-4]);
      Modelica.Blocks.Math.Gain K1(k=k1) 
        annotation (extent=[50,-2; 60,10],    rotation=0);
      Modelica.Blocks.Math.Gain K2(k=k2) 
        annotation (extent=[50,-20; 60,-8],   rotation=0);
      Modelica.Blocks.Math.Gain K3(k=k3) 
        annotation (extent=[48,-38; 58,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Derivative2 
            annotation (extent=[18,-36; 28,-26]);
        Modelica.Blocks.Continuous.Integrator Integrator1 
          annotation (extent=[-2,20; 18,40]);
    equation 
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
          connect(K1.y, Add3_1.u1) annotation (points=[60.5,4; 66,4; 66,-6; 72,-6],
              style(color=74, rgbcolor={0,0,127}));
          connect(K2.y, Add3_1.u2) annotation (points=[60.5,-14; 72,-14], style(
                color=74, rgbcolor={0,0,127}));
          connect(K3.y, Add3_1.u3) annotation (points=[58.5,-32; 66,-32; 66,-22;
                72,-22], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative2.y, K3.u) annotation (points=[28.5,-31; 37.25,-31;
                37.25,-32; 47,-32], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, K2.u) annotation (points=[6.5,-1; 28.25,-1;
                28.25,-14; 49,-14], style(color=74, rgbcolor={0,0,127}));
          connect(Derivative1.y, Derivative2.u) annotation (points=[6.5,-1; 6.5,
                -30.5; 17,-30.5; 17,-31], style(color=74, rgbcolor={0,0,127}));
          connect(Add3_1.y, tmp.u) annotation (points=[95,-14; 135,-14; 135,-32.8],
              style(color=74, rgbcolor={0,0,127}));
          connect(Sensor[6], Derivative1.u) annotation (points=[-90,-33.6667;
              -48,-33.6667; -48,-1; -5,-1],
                                          style(color=74, rgbcolor={0,0,127}));
          connect(Torque1.tau, tmp.y) annotation (points=[94,-62.6; 116,-62.6;
                116,-46.6; 135,-46.6], style(color=74, rgbcolor={0,0,127}));
        connect(Integrator1.y, K1.u) annotation (points=[19,30; 34,30; 34,4; 49,4],
            style(color=74, rgbcolor={0,0,127}));
        
        connect(Derivative1.y, Integrator1.u) annotation (points=[6.5,-1; 14,-1;
              14,8; -20,8; -20,30; -4,30], style(color=74, rgbcolor={0,0,127}));
    end Stabilizer_3;
      
    model Stabilizer_Compensation 
        import Modelica.Math.*;
      parameter Real k2=6 "Roll Angular Speed Forward Coefficient";
      parameter Real k3=4 "Roll Angular Acceleration Forward Coefficient";
      Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
        annotation (extent=[88,-78; 100,-64],   rotation=270);
      Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
        annotation (extent=[80, -100; 100, -80]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-100,-52; -80,-32]);
          Modelica.Blocks.Continuous.Derivative Der1 
            annotation (extent=[-6,-6; 4,4]);
      Modelica.Blocks.Math.Gain K2(k=k2) 
        annotation (extent=[50,-20; 60,-8],   rotation=0);
      Modelica.Blocks.Math.Gain K3(k=k3) 
        annotation (extent=[52,-38; 62,-26],  rotation=0);
          Modelica.Blocks.Continuous.Derivative Der2 
            annotation (extent=[20,-36; 30,-26]);
        Modelica.Blocks.Math.Add3 Add3_1(
          k2=-1,
          k3=-1,
          k1=+1) annotation (extent=[76,-32; 96,-12]);
        Modelica.Blocks.Math.Product Product2 annotation (extent=[32,42; 52,62]);
        Modelica.Blocks.Tables.CombiTable1D roll2tau(table=[0.002,0.01; 0.004,
              0.02; 0.006,0.03; 0.008,0.04; 0.01,0.05; 0.02,0.1; 0.04,0.2;
              0.085,0.4; 0.1,0.5; 0.2454,1; 0.4,1.2; 0.5,1.22], smoothness=
              Modelica.Blocks.Types.Smoothness.ContinuousDerivative) 
          annotation (extent=[-20,60; 0,80]);
        Modelica.Blocks.Tables.CombiTable1D V2tau(smoothness=Modelica.Blocks.
              Types.Smoothness.ContinuousDerivative, table=[0,1; 8,1; 10,1; 15,
              1]) annotation (extent=[-40,28; -20,48]);
    equation 
        
      connect(Torque1.flange_b, flange_steer) annotation (points=[94,-78; 94,-90;
            90,-90], style(color=0, rgbcolor={0,0,0}));
      annotation (Diagram);
        connect(Der1.y, K2.u)          annotation (points=[4.5,-1; 28.25,-1;
              28.25,-14; 49,-14],   style(color=74, rgbcolor={0,0,127}));
        connect(Der1.y, Der2.u)                 annotation (points=[4.5,-1; 4.5,
              -30.5; 19,-30.5; 19,-31],   style(color=74, rgbcolor={0,0,127}));
        connect(Sensor[6], Der1.u)          annotation (points=[-90,-33.6667;
              -48,-33.6667; -48,-1; -7,-1],
                                          style(color=74, rgbcolor={0,0,127}));
    //K3.u = if (abs(Der2.y)<0.01) then 0 else Der2.y;
        
        connect(Der2.y, K3.u) annotation (points=[30.5,-31; 41.25,-31; 41.25,
              -32; 51,-32], style(color=74, rgbcolor={0,0,127}));
        connect(K3.y, Add3_1.u3) annotation (points=[62.5,-32; 68,-32; 68,-30;
              74,-30], style(color=74, rgbcolor={0,0,127}));
        connect(K2.y, Add3_1.u2) annotation (points=[60.5,-14; 66,-14; 66,-22;
              74,-22], style(color=74, rgbcolor={0,0,127}));
        connect(Add3_1.y, Torque1.tau) annotation (points=[97,-22; 108,-22; 108,
              -46; 94,-46; 94,-62.6], style(color=74, rgbcolor={0,0,127}));
        connect(Product2.y, Add3_1.u1) annotation (points=[53,52; 64,52; 64,0;
              74,0; 74,-14], style(color=74, rgbcolor={0,0,127}));
        connect(V2tau.y[1], Product2.u2) annotation (points=[-19,38; -4,38; -4,
              46; 30,46], style(color=74, rgbcolor={0,0,127}));
        connect(Sensor[4], V2tau.u[1]) annotation (points=[-90,-40.3333; -82,
              -40.3333; -82,-40; -70,-40; -70,38; -42,38], style(color=74,
              rgbcolor={0,0,127}));
        connect(roll2tau.y[1], Product2.u1) annotation (points=[1,70; 16,70; 16,
              58; 30,58], style(color=74, rgbcolor={0,0,127}));
        connect(Sensor[6], roll2tau.u[1]) annotation (points=[-90,-33.6667; -90,
              70; -22,70], style(color=74, rgbcolor={0,0,127}));
    end Stabilizer_Compensation;
      
      model C2roll 
        
        Modelica.Blocks.Math.Atan Atan1 annotation (extent=[20,40; 40,60]);
        Modelica.Blocks.Math.Product Product1 
          annotation (extent=[-78,60; -58,80]);
        annotation (Diagram);
        Modelica.Blocks.Interfaces.RealInput Vx2 
          annotation (extent=[-110,60; -90,80]);
        Modelica.Blocks.Interfaces.RealInput C 
          annotation (extent=[-110,20; -90,40]);
        Modelica.Blocks.Interfaces.RealOutput roll 
          annotation (extent=[80,40; 100,60]);
        Modelica.Blocks.Sources.Constant Constant1(k=1/9.8066) 
          annotation (extent=[-100,-20; -80,0]);
        Modelica.Blocks.Math.Product Product2 
          annotation (extent=[-73,14; -53,34]);
        Modelica.Blocks.Math.Product Product3 annotation (extent=[-19,40; 1,60]);
      equation 
        connect(Product1.u1, Vx2) annotation (points=[-80,76; -87,76; -87,70;
              -100,70], style(color=74, rgbcolor={0,0,127}));
        connect(Vx2, Product1.u2) annotation (points=[-100,70; -87,70; -87,64;
              -80,64], style(color=74, rgbcolor={0,0,127}));
        connect(Atan1.y, roll) annotation (points=[41,50; 90,50], style(color=
                74, rgbcolor={0,0,127}));
        connect(C, Product2.u1) annotation (points=[-100,30; -75,30], style(
              color=74, rgbcolor={0,0,127}));
        connect(Constant1.y, Product2.u2) annotation (points=[-79,-10; -68,-10;
              -68,8; -84,8; -84,18; -75,18], style(color=74, rgbcolor={0,0,127}));
        connect(Product1.y, Product3.u1) annotation (points=[-57,70; -34,70;
              -34,56; -21,56], style(color=74, rgbcolor={0,0,127}));
        connect(Product2.y, Product3.u2) annotation (points=[-52,24; -32,24;
              -32,44; -21,44], style(color=74, rgbcolor={0,0,127}));
        connect(Product3.y, Atan1.u) annotation (points=[2,50; 18,50], style(
              color=74, rgbcolor={0,0,127}));
      end C2roll;
      
      model Roll2C 
        
        Modelica.Blocks.Math.Product Product1 
          annotation (extent=[-80,-20; -60,0]);
        annotation (Diagram);
        Modelica.Blocks.Interfaces.RealInput Vx2 
          annotation (extent=[-110,-20; -90,0]);
        Modelica.Blocks.Interfaces.RealInput Roll 
          annotation (extent=[-110,20; -90,40]);
        Modelica.Blocks.Interfaces.RealOutput C 
          annotation (extent=[80,40; 100,60]);
        Modelica.Blocks.Sources.Constant Constant1(k=9.8066) 
          annotation (extent=[-80,60; -60,80]);
        Modelica.Blocks.Math.Product Product3 
          annotation (extent=[-39,30; -19,50]);
        Modelica.Blocks.Math.Tan Tan1 annotation (extent=[-80,20; -60,40]);
        Modelica.Blocks.Math.Division Division1 annotation (extent=[4,6; 24,26]);
        Modelica.Blocks.Sources.Constant Constant2(k=1e-8) 
          annotation (extent=[-42,-66; -22,-46]);
        Modelica.Blocks.Math.Add Add1 annotation (extent=[-34,-10; -14,10]);
      equation 
        connect(Product1.u1, Vx2) annotation (points=[-82,-4; -89,-4; -89,-10;
              -100,-10], style(color=74, rgbcolor={0,0,127}));
        connect(Vx2, Product1.u2) annotation (points=[-100,-10; -89,-10; -89,
              -16; -82,-16], style(color=74, rgbcolor={0,0,127}));
        connect(Roll, Tan1.u) annotation (points=[-100,30; -82,30], style(color=
               74, rgbcolor={0,0,127}));
        connect(Tan1.y, Product3.u2) annotation (points=[-59,30; -50,30; -50,34;
              -41,34], style(color=74, rgbcolor={0,0,127}));
        connect(Constant1.y, Product3.u1) annotation (points=[-59,70; -50,70;
              -50,46; -41,46], style(color=74, rgbcolor={0,0,127}));
        connect(Product3.y, Division1.u1) annotation (points=[-18,40; -8,40; -8,
              22; 2,22], style(color=74, rgbcolor={0,0,127}));
        connect(Division1.y, C) annotation (points=[25,16; 53.5,16; 53.5,50; 90,
              50], style(color=74, rgbcolor={0,0,127}));
        connect(Add1.y, Division1.u2) annotation (points=[-13,0; -6,0; -6,10; 2,
              10], style(color=74, rgbcolor={0,0,127}));
        connect(Product1.y, Add1.u1) annotation (points=[-59,-10; -48,-10; -48,
              6; -36,6], style(color=74, rgbcolor={0,0,127}));
        connect(Add1.u2, Constant2.y) annotation (points=[-36,-6; -36,-38; -12,
              -38; -12,-50; -21,-50; -21,-56], style(color=74, rgbcolor={0,0,
                127}));
      end Roll2C;
    end Steering_Control;
    
  package Paths 
      
  model Path1 
    Modelica.Blocks.Math.Sin Sin1 annotation (extent=[4, 52; 16, 62]);
    Modelica.Blocks.Sources.Clock Clock1 annotation (extent=[-80, 44; -68, 56]);
    Modelica.Blocks.Math.Add Add1 annotation (extent=[-34, 34; -14, 54]);
    Modelica.Blocks.Math.Gain Gain1(k=0.1) 
      annotation (extent=[-56, 44; -44, 54]);
    Modelica.Blocks.Math.Gain Gain2(k=0.07) 
      annotation (extent=[26, 52; 38, 60]);
    Modelica.Blocks.Sources.Constant Constant1(k=-2) 
      annotation (extent=[-86, 4; -66, 24]);
    Modelica.Blocks.Interfaces.RealOutput outPort1[2] 
      annotation (extent=[80, 40; 100, 60]);
    annotation (Diagram);
    Modelica.Blocks.Math.Sin Sin2 annotation (extent=[0,-16; 12,-6]);
    Modelica.Blocks.Sources.Clock Clock2(offset=0.5) 
                                         annotation (extent=[-84,-24; -72,-12]);
    Modelica.Blocks.Math.Add Add2 annotation (extent=[-38,-34; -18,-14]);
    Modelica.Blocks.Math.Gain Gain3(k=0.1) 
      annotation (extent=[-60,-24; -48,-14]);
    Modelica.Blocks.Math.Gain Gain4(k=0.07) 
      annotation (extent=[22,-16; 34,-8]);
    Modelica.Blocks.Sources.Constant Constant2(k=-2) 
      annotation (extent=[-90,-64; -70,-44]);
  equation 
        connect(Clock1.y, Gain1.u) annotation (points=[-67.4,50; -62.3,50;
              -62.3,49; -57.2,49], style(color=74, rgbcolor={0,0,127}));
        connect(Gain1.y, Add1.u1) annotation (points=[-43.4,49; -39.7,49; -39.7,
              50; -36,50], style(color=74, rgbcolor={0,0,127}));
        connect(Add1.y, Sin1.u) annotation (points=[-13,44; -5.5,44; -5.5,57;
              2.8,57], style(color=74, rgbcolor={0,0,127}));
        connect(Sin1.y, Gain2.u) annotation (points=[16.6,57; 20.3,57; 20.3,56;
              24.8,56], style(color=74, rgbcolor={0,0,127}));
        connect(Gain2.y, outPort1[2]) annotation (points=[38.6,56; 60,56; 60,55;
              90,55], style(color=74, rgbcolor={0,0,127}));
        connect(Constant1.y, Add1.u2) annotation (points=[-65,14; -52,14; -52,
              38; -36,38], style(color=74, rgbcolor={0,0,127}));
        connect(Clock2.y, Gain3.u) annotation (points=[-71.4,-18; -66.3,-18;
              -66.3,-19; -61.2,-19], style(color=74, rgbcolor={0,0,127}));
        connect(Gain3.y, Add2.u1) annotation (points=[-47.4,-19; -43.7,-19;
              -43.7,-18; -40,-18], style(color=74, rgbcolor={0,0,127}));
        connect(Add2.y, Sin2.u) annotation (points=[-17,-24; -9.5,-24; -9.5,-11;
              -1.2,-11], style(color=74, rgbcolor={0,0,127}));
        connect(Sin2.y, Gain4.u) annotation (points=[12.6,-11; 16.3,-11; 16.3,
              -12; 20.8,-12], style(color=74, rgbcolor={0,0,127}));
        connect(Constant2.y, Add2.u2) annotation (points=[-69,-54; -56,-54; -56,
              -30; -40,-30], style(color=74, rgbcolor={0,0,127}));
        connect(Gain4.y, outPort1[1]) annotation (points=[34.6,-12; 58,-12; 58,
              45; 90,45], style(color=74, rgbcolor={0,0,127}));
  end Path1;
      
  model Path2 
    Modelica.Blocks.Sources.Ramp Ramp1(
          duration=duration,
          height=height,
          offset=0,
          startTime=startTime) 
                         annotation (extent=[-40,-20; -20,0]);
    annotation (Diagram);
    parameter Real height=0.15;
    parameter Real duration=1;
    parameter Modelica.SIunits.Time startTime=0;
    parameter Real anticipo=0.5;
    Modelica.Blocks.Sources.Ramp Ramp2(
          duration=duration,
          height=height,
          offset=0,
          startTime=startTime - anticipo) 
                         annotation (extent=[-40,20; -20,40]);
        Modelica.Blocks.Interfaces.RealOutput y1[2] 
          annotation (extent=[80,0; 100,20]);
  equation 
        connect(Ramp1.y, y1[1]) annotation (points=[-19,-10; 32,-10; 32,5; 90,5],
            style(color=74, rgbcolor={0,0,127}));
        connect(Ramp2.y, y1[2]) annotation (points=[-19,30; 32,30; 32,15; 90,15],
            style(color=74, rgbcolor={0,0,127}));
  end Path2;
      
  model Path3 
    Modelica.Blocks.Math.Sin Sin1 annotation (extent=[-2,-58; 10,-48]);
    Modelica.Blocks.Sources.Clock Clock1(startTime=0.5) 
                                         annotation (extent=[-100,-58; -88,-46]);
    Modelica.Blocks.Math.Gain Gain2(k=k2) annotation (extent=[22,-56; 34,-48]);
    Modelica.Blocks.Interfaces.RealOutput outPort1[2] 
      annotation (extent=[82, 48; 102, 68]);
    Modelica.Blocks.Math.Add Add1 annotation (extent=[-62,-60; -50,-46]);
    Modelica.Blocks.Sources.Constant Constant1(k=-1) 
      annotation (extent=[-100,-98; -80,-78]);
    Modelica.Blocks.Sources.Constant Constant2(k=0) 
      annotation (extent=[-98,-34; -86,-22]);
    Modelica.Blocks.Math.Max Max1 annotation (extent=[-46,-56; -34,-44]);
    Modelica.Blocks.Math.Gain Gain1(k=k1) annotation (extent=[-26,-58; -14,-48]);
    parameter Real k1=0.2 "Period";
    parameter Real k2=0.077 "Amplitude";
    Modelica.Blocks.Math.Sin Sin2 annotation (extent=[-2,56; 10,66]);
    Modelica.Blocks.Sources.Clock Clock2 annotation (extent=[-104,56; -92,68]);
    Modelica.Blocks.Math.Gain Gain3(k=k2) annotation (extent=[18,58; 30,66]);
    Modelica.Blocks.Math.Add Add2 annotation (extent=[-66,54; -54,68]);
    Modelica.Blocks.Sources.Constant Constant3(k=-8) 
      annotation (extent=[-98,0; -78,20]);
    Modelica.Blocks.Sources.Constant Constant4(k=0) 
      annotation (extent=[-102,80; -90,92]);
    Modelica.Blocks.Math.Max Max2 annotation (extent=[-42,58; -30,70]);
    Modelica.Blocks.Math.Gain Gain4(k=k1) annotation (extent=[-20,56; -8,66]);
    annotation (Diagram);
  equation 
        connect(Gain2.y, outPort1[1]) annotation (points=[34.6,-52; 70.3,-52;
              70.3,53; 92,53], style(color=74, rgbcolor={0,0,127}));
        connect(Gain3.y, outPort1[2]) annotation (points=[30.6,62; 58,62; 58,63;
              92,63], style(color=74, rgbcolor={0,0,127}));
        connect(Sin2.y, Gain3.u) annotation (points=[10.6,61; 9.3,61; 9.3,62;
              16.8,62], style(color=74, rgbcolor={0,0,127}));
        connect(Gain4.y, Sin2.u) annotation (points=[-7.4,61; -3.2,61], style(
              color=74, rgbcolor={0,0,127}));
        connect(Max2.y, Gain4.u) annotation (points=[-29.4,64; -30,64; -30,61;
              -21.2,61], style(color=74, rgbcolor={0,0,127}));
        connect(Constant4.y, Max2.u1) annotation (points=[-89.4,86; -50,86; -50,
              67.6; -43.2,67.6], style(color=74, rgbcolor={0,0,127}));
        connect(Add2.y, Max2.u2) annotation (points=[-53.4,61; -48.7,61; -48.7,
              60.4; -43.2,60.4], style(color=74, rgbcolor={0,0,127}));
        connect(Clock2.y, Add2.u1) annotation (points=[-91.4,62; -80,62; -80,
              65.2; -67.2,65.2], style(color=74, rgbcolor={0,0,127}));
        connect(Constant3.y, Add2.u2) annotation (points=[-77,10; -72,10; -72,
              56.8; -67.2,56.8], style(color=74, rgbcolor={0,0,127}));
        connect(Constant2.y, Max1.u1) annotation (points=[-85.4,-28; -47.2,-28;
              -47.2,-46.4], style(color=74, rgbcolor={0,0,127}));
        connect(Clock1.y, Add1.u1) annotation (points=[-87.4,-52; -76,-52; -76,
              -48.8; -63.2,-48.8], style(color=74, rgbcolor={0,0,127}));
        connect(Constant1.y, Add1.u2) annotation (points=[-79,-88; -72,-88; -72,
              -57.2; -63.2,-57.2], style(color=74, rgbcolor={0,0,127}));
        connect(Add1.y, Max1.u2) annotation (points=[-49.4,-53; -45.7,-53;
              -45.7,-53.6; -47.2,-53.6], style(color=74, rgbcolor={0,0,127}));
        connect(Max1.y, Gain1.u) annotation (points=[-33.4,-50; -30,-50; -30,
              -53; -27.2,-53], style(color=74, rgbcolor={0,0,127}));
        connect(Gain1.y, Sin1.u) annotation (points=[-13.4,-53; -8.7,-53; -8.7,
              -53; -3.2,-53], style(color=74, rgbcolor={0,0,127}));
        connect(Sin1.y, Gain2.u) annotation (points=[10.6,-53; 16.3,-53; 16.3,
              -52; 20.8,-52], style(color=74, rgbcolor={0,0,127}));
  end Path3;
      
    model Joystick_1 
        Modelica.Blocks.Sources.TimeTable TimeTable1(table=table) 
          annotation (extent=[-100,0; -80,20]);
        annotation (Diagram);
        Modelica.Blocks.Continuous.TransferFunction TransferFunction1(a={1/8,1}) 
          annotation (extent=[-40,0; -20,20]);
        parameter Real table[:,2]=[0, 0; 5, 0; 5.1, 50; 6.4, 50; 6.5, 0; 10, 0; 10.1, -4; 10.4, -4; 10.5, 0; 18, 0; 18.1, 5; 18.4, 5; 18.5, 0; 20, 0; 30, 0; 31, 0.1; 35, 0; 40, 0];
        Modelica.Mechanics.Rotational.Torque Torque1 
          annotation (extent=[20,0; 40,20]);
        Modelica.Mechanics.Rotational.Interfaces.Flange_b to_Steering 
          annotation (extent=[80,0; 100,20]);
    equation 
        connect(TimeTable1.y, TransferFunction1.u) annotation (points=[-79,10;
              -42,10],style(color=74, rgbcolor={0,0,127}));
        connect(TransferFunction1.y, Torque1.tau) annotation (points=[-19,10;
              18,10], style(color=74, rgbcolor={0,0,127}));
        connect(Torque1.flange_b, to_Steering) 
          annotation (points=[40,10; 90,10], style(color=0, rgbcolor={0,0,0}));
    end Joystick_1;
      
    model Joystick_2 
        Modelica.Blocks.Sources.TimeTable TimeTable1(table=table) 
          annotation (extent=[-40,0; -20,20]);
        annotation (Diagram);
        Modelica.Blocks.Continuous.TransferFunction TransferFunction1(a={1/8,1}) 
          annotation (extent=[20,0; 40,20]);
        Modelica.Blocks.Interfaces.RealOutput to_Steer_and_Control 
          annotation (extent=[84,0; 104,20]);
        parameter Real table[:,2]=[0, 0; 5, 0; 5.1, 50; 6.4, 50; 6.5, 0; 10, 0; 10.1, -4; 10.4, -4; 10.5, 0; 18, 0; 18.1, 5; 18.4, 5; 18.5, 0; 20, 0; 30, 0; 31, 0.1; 35, 0; 40, 0];
    equation 
        connect(TimeTable1.y, TransferFunction1.u) annotation (points=[-19,10;
              18,10], style(color=74, rgbcolor={0,0,127}));
        connect(TransferFunction1.y, to_Steer_and_Control) annotation (points=[
              41,10; 94,10], style(color=74, rgbcolor={0,0,127}));
    end Joystick_2;
  end Paths;
    
  model Torque_Control 
      import Modelica.Constants.*;
      import Modelica.Mechanics.MultiBody.Frames.*;
      import Modelica.Math.*;
    Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_Seaddle 
      annotation (extent=[90,20; 110,40],        rotation=0);
    Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
      annotation (extent=[62,-80; 82,-60]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_rear_hub 
      annotation (extent=[80, -100; 100, -80]);
    Modelica.Mechanics.MultiBody.Sensors.AbsoluteSensor AbsoluteSensor1(
      get_r_abs=false,
      get_v_abs=true,
      resolveInFrame_a=true,
      get_z_abs=false,
      get_angles=false,
      get_w_abs=false,
      animation=false) annotation (extent=[-28,46; -8,66], rotation=90);
    annotation (Diagram);
    Modelica.Blocks.Math.Gain tmp(k=-1)   annotation (extent=[-4,-20; 8,-8],
          rotation=180);
    Modelica.Blocks.Math.Add Add(k1=+1, k2=-1) 
      annotation (extent=[6,74; 16,86]);
    Modelica.Blocks.Continuous.PI PI1(T=T, k=k) 
      annotation (extent=[24,74; 38,86]);
    Modelica.Blocks.Interfaces.RealInput SP_Speed 
      annotation (extent=[-100, 80; -80, 100]);
    parameter Real k=25;
    parameter Modelica.SIunits.Time T=1;
    parameter Real Tstart=20;
    parameter Real Tfinish=25;
      
      Modelica.Blocks.Interfaces.RealOutput y1 
        annotation (extent=[76,80; 96,100], rotation=90);
    Modelica.Blocks.Interfaces.RealInput Rear_Slip 
      annotation (extent=[-72,-100; -52,-80], rotation=90);
    parameter Modelica.SIunits.Time Td=0.1 "Time Constant of Derivative block";
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed1(
        tableOnFile=true,
        tableName="vx_tab",
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
      fileName="C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat",
        startTime=7) 
        annotation (extent=[-92,-8; -72,12],   rotation=0);
      Modelica.Blocks.Math.Gain gain(k=0.2) 
        annotation (extent=[-30,4; -14,16]);
      Modelica.Blocks.Math.Add add annotation (extent=[-58,0; -38,20]);
      Modelica.Blocks.Math.Add add1 
        annotation (extent=[22,-24; 42,-4], rotation=180);
  equation 
  // Torque1.tau=if (time<Tstart or time>Tfinish) and tmp.y<0 and abs(Rear_Slip)<.15 then if tmp.y>-800 then tmp.y else -800 else 0;
  // y1=if (time<Tstart or time>Tfinish) and tmp.y>0 then if tmp.y<1200 then tmp.y/1400 else 1 else 0;
  Torque1.tau=if (time<Tstart or time>Tfinish) and abs(Rear_Slip)<0.15 then if tmp.y>-700 then tmp.y else -700 else 0;
  y1=0;
   Add.u1=if time<Tstart or time>Tfinish then SP_Speed else AbsoluteSensor1.y[1];
    connect(Torque1.flange_b, flange_rear_hub) annotation (points=[82,-70; 90,
            -70; 90,-90],style(color=0, rgbcolor={0,0,0}));
    connect(AbsoluteSensor1.frame_a, frame_Seaddle) annotation (points=[-18,46;
            -18,30; 100,30],       style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
      connect(Add.y, PI1.u)  annotation (points=[16.5,80; 22.6,80],
                      style(color=74, rgbcolor={0,0,127}));
      connect(AbsoluteSensor1.y[1], Add.u2)  annotation (points=[-18,67; -18,
            76.4; 5,76.4],        style(color=74, rgbcolor={0,0,127}));
      connect(Speed1.y[1], add.u2) annotation (points=[-71,2; -66,2; -66,4; -60,
            4], style(color=74, rgbcolor={0,0,127}));
      connect(add.y, gain.u) annotation (points=[-37,10; -31.6,10], style(color=
             74, rgbcolor={0,0,127}));
      connect(tmp.u, add1.y) annotation (points=[9.2,-14; 15.1,-14; 15.1,-14;
            21,-14], style(color=74, rgbcolor={0,0,127}));
      connect(gain.y, add1.u2) annotation (points=[-13.2,10; 54,10; 54,-8; 44,
            -8], style(color=74, rgbcolor={0,0,127}));
      connect(PI1.y, add1.u1) annotation (points=[38.7,80; 68,80; 68,-20; 44,
            -20], style(color=74, rgbcolor={0,0,127}));
      connect(add.u1, SP_Speed) annotation (points=[-60,16; -66,16; -66,90; -90,
            90], style(color=74, rgbcolor={0,0,127}));
  end Torque_Control;
    
    model Speed_Control 
      
      Modelica.Blocks.Interfaces.RealInput Speed_SP 
        annotation (extent=[-130,70; -90,110]);
      Modelica.Blocks.Interfaces.RealOutput Rear_Torque 
        annotation (extent=[100,80; 120,100]);
      Modelica.Blocks.Interfaces.RealOutput Brake 
        annotation (extent=[100,-82; 120,-62]);
      annotation (Diagram);
      Wheel.Friction_Model.Interfaces.Friction_Connector friction_Connector 
        annotation (extent=[-110,-82; -90,-58]);
      Modelica.Blocks.Interfaces.RealInput Sensor[6] 
        annotation (extent=[-130,30; -90,70]);
      Modelica.Blocks.Continuous.LimPID PID(
        k=k,
        Ti=Ti,
        yMax=400) annotation (extent=[-80,80; -60,100]);
      Modelica.Blocks.Nonlinear.Limiter limiter(uMax=0, uMin=-400) 
        annotation (extent=[-16,80; 4,100]);
      Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=400, uMin=0) 
        annotation (extent=[20,20; 40,40]);
      Modelica.Blocks.Math.Gain gain(k=(1/400)*0.3) 
                                              annotation (extent=[52,20; 72,40]);
      parameter Real k=1 "Gain of controller";
      parameter Modelica.SIunits.Time Ti=0.5 
        "Time constant of Integrator block";
      parameter Real k_fw=10 "Gain of fw";
      Modelica.Blocks.Logical.LessEqual lessEqual 
        annotation (extent=[-20,-40; 0,-20]);
      Modelica.Blocks.Sources.Constant const(k=0.1) 
        annotation (extent=[-60,-80; -40,-60]);
      Modelica.Blocks.Logical.Switch switch1 annotation (extent=[48,80; 68,100]);
      Modelica.Blocks.Sources.Constant const1(k=0) 
        annotation (extent=[18,54; 38,74]);
      Modelica.Blocks.Interfaces.RealInput FW 
        annotation (extent=[-120,-30; -80,10]);
      Modelica.Blocks.Math.Feedback feedback annotation (extent=[-78,6; -58,26]);
      Modelica.Blocks.Math.Gain gain1(k=k_fw) 
                                      annotation (extent=[-54,6; -34,26]);
      Modelica.Blocks.Math.Add add annotation (extent=[-48,80; -28,100]);
    equation 
      connect(Speed_SP, PID.u_s) annotation (points=[-110,90; -82,90], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(Sensor[4], PID.u_m) annotation (points=[-110,53.3333; -70,53.3333;
            -70,78], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(limiter1.y, gain.u) annotation (points=[41,30; 50,30], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(gain.y, Brake) annotation (points=[73,30; 84,30; 84,-72; 110,-72],
          style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(friction_Connector.slip, lessEqual.u1) annotation (points=[-91,
            -72.4; -70,-72.4; -70,-30; -22,-30], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(const.y, lessEqual.u2) annotation (points=[-39,-70; -30,-70; -30,
            -38; -22,-38], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(switch1.u1, limiter.y) annotation (points=[46,98; 10,98; 10,90; 5,
            90], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(switch1.y, Rear_Torque) annotation (points=[69,90; 110,90], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(const1.y, switch1.u3) annotation (points=[39,64; 42,64; 42,82; 46,
            82], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(Sensor[6], feedback.u1) annotation (points=[-110,66.6667; -82,
            66.6667; -82,16; -76,16], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(FW, feedback.u2) annotation (points=[-100,-10; -84,-10; -84,-8;
            -68,-8; -68,8], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(feedback.y, gain1.u) annotation (points=[-59,16; -56,16], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(PID.y, add.u1) annotation (points=[-59,90; -56,90; -56,96; -50,96],
          style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(add.y, limiter.u) annotation (points=[-27,90; -18,90], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(gain1.y, add.u2) annotation (points=[-33,16; -28,16; -28,30; -58,
            30; -58,84; -50,84], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(add.y, limiter1.u) annotation (points=[-27,90; -22,90; -22,30; 18,
            30], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(lessEqual.y, switch1.u2) annotation (points=[1,-30; 14,-30; 14,90;
            46,90], style(
          color=5,
          rgbcolor={255,0,255},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
    end Speed_Control;
    
  end Driver;
  
  package Environments "This class contains the road model" 
    
  annotation (
  Documentation(info="<html>
<p> This package contain all that concern to enviroment as road, climatic condition,...
</HTML>"));
    
    model Road 
      
    annotation (
    Documentation(info="<html>
<p> This class is similar to Road block of VehicleDynamics library, with the addition of third dimension. It has been introduced variable 
altitude that depends from x and y coordinate.
</HTML>"));
      
      annotation (
        defaultComponentName="road",
        defaultComponentPrefixes="inner",
        Icon(
          Polygon(points=[-36, -6; -99.2, -80; -99.2, -98.8; 99, -98.8; 99, -80;
                26, -6; -36, -6], style(color=10, fillColor=10)),
          Rectangle(extent=[-100, 60; 100, -100], style(color=0, rgbcolor={0,0,0})),
          Polygon(points=[-12, -92; 8, -92; 4, -56; -8, -56; -12, -92], style(
                color=8, fillColor=8)),
          Polygon(points=[-6, -46; 2, -46; 0, -28; -4, -28; -6, -46], style(color=
                 8, fillColor=8)),
          Polygon(points=[-4, -20; 0, -20; -2, -6; -2, -6; -4, -20], style(color=
                  8, fillColor=8)),
          Text(
            extent=[-100, 32; 100, 60],
            style(color=0, rgbcolor={0,0,0}),
            string="Road "),
          Rectangle(extent=[44, -28; 50, 8], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=42,
              rgbfillColor={127,0,0})),
          Polygon(points=[30, 12; 30, 18; 38, 16; 38, 22; 46, 22; 48, 26; 54, 22;
                60, 24; 62, 16; 56, 14; 62, 10; 58, 8; 58, 0; 56, 4; 52, 0; 46, 2;
                40, -2; 40, 2; 32, 2; 36, 8; 30, 8; 34, 12; 32, 14; 30, 12],
              style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=58,
              rgbfillColor={0,193,0})),
          Rectangle(extent=[62, -46; 68, -10], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=42,
              rgbfillColor={127,0,0})),
          Polygon(points=[48, -6; 48, 0; 56, -2; 56, 4; 64, 4; 66, 8; 72, 4; 78,
                6; 80, -2; 74, -4; 80, -8; 76, -10; 76, -18; 74, -14; 70, -18; 64,
                -16; 58, -20; 58, -16; 50, -16; 54, -10; 48, -10; 52, -6; 50, -4;
                48, -6], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=58,
              rgbfillColor={0,193,0})),
          Rectangle(extent=[82, -64; 88, -28], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=42,
              rgbfillColor={127,0,0})),
          Polygon(points=[68, -24; 68, -18; 76, -20; 76, -14; 84, -14; 86, -10;
                92, -14; 98, -12; 100, -20; 94, -22; 100, -26; 96, -28; 96, -36;
                94, -32; 90, -36; 84, -34; 78, -38; 78, -34; 70, -34; 74, -28; 68,
                -28; 72, -24; 70, -22; 68, -24], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=58,
              rgbfillColor={0,193,0})),
          Rectangle(extent=[-52, -20; -46, 16], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=42,
              rgbfillColor={127,0,0})),
          Polygon(points=[-66, 18; -66, 24; -58, 22; -58, 28; -50, 28; -48, 32; -42,
                28; -36, 30; -34, 22; -40, 20; -34, 16; -38, 14; -38, 6; -40, 10;
                -44, 6; -50, 8; -56, 4; -56, 8; -64, 8; -60, 14; -66, 14; -62, 18;
                -64, 20; -66, 18], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=58,
              rgbfillColor={0,193,0})),
          Rectangle(extent=[-68, -40; -62, -4], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=42,
              rgbfillColor={127,0,0})),
          Polygon(points=[-82, 0; -82, 6; -74, 4; -74, 10; -66, 10; -64, 14; -58,
                10; -52, 12; -50, 4; -56, 2; -50, -2; -54, -4; -54, -12; -56, -8;
                -60, -12; -66, -10; -72, -14; -72, -10; -80, -10; -76, -4; -82, -4;
                -78, 0; -80, 2; -82, 0], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=58,
              rgbfillColor={0,193,0})),
          Rectangle(extent=[-86, -60; -80, -24], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=42,
              rgbfillColor={127,0,0})),
          Polygon(points=[-100, -20; -100, -14; -92, -16; -92, -10; -84, -10; -82,
                -6; -76, -10; -70, -8; -68, -16; -74, -18; -68, -22; -72, -24; -72,
                -32; -74, -28; -78, -32; -84, -30; -90, -34; -90, -30; -98, -30;
                -94, -24; -100, -24; -96, -20; -98, -18; -100, -20], style(
              color=0,
              rgbcolor={0,0,0},
              gradient=1,
              fillColor=58,
              rgbfillColor={0,193,0}))));
      
      import Modelica.Math.*;
      import MotorcycleDynamics;
      
      parameter Integer choice=1 
        "0 per strada piana [parametro d], 1 per strada con salita [parametri d e], 2 per strada a sella [parametri a,b,c,d]";
      parameter Real a=8;
      parameter Real b=12;
      parameter Real c=1;
      parameter Real d=0.05 "Altitude";
      parameter Real e=2;
      parameter Real f=0.15;
      
      annotation (smoothOrder=1);
      
      function get_nx = get_nx_pro (
          choice=choice,
          a=a,
          b=b,
          c=c,
          d=d,
          e=e,
          f=f);
      
      function get_ny = get_ny_pro (
          choice=choice,
          a=a,
          b=b,
          c=c,
          d=d,
          e=e,
          f=f);
      
      function get_z = get_z_pro (
          choice=choice,
          a=a,
          b=b,
          c=c,
          d=d,
          e=e,
          f=f);
      
      function get_mue "Return road Mue from x,y" 
        input Real x;
        input Real y;
        output Real mue;
      algorithm 
      //  mue := if (x>20 and x<40 and y>-236.537 and y<-133.718) then 1.2 else if (x>-15 and x<66 and y>-85 and y<-30) then 0.8 else 1;
      mue:=1;
      end get_mue;
      
    protected 
      function get_z_pro "Return road height altitude from x,y" 
        input Real x;
        input Real y;
        input Integer choice;
        input Real a;
        input Real b;
        input Real c;
        input Real d;
        input Real e;
        input Real f;
        
        output Real z;
      protected 
        Real g;
        constant Real pi=Modelica.Constants.pi;
      algorithm 
        g := (atan(10*(x - e)) + pi/2)/pi;
        z := if (choice == 0) then d else if (choice == 1) then d*(1 - g) + (f*(x
           - e) + d)*g else ((x/a)^2 - (y/b)^2)*c + d;
        annotation (smoothOrder=1);
      end get_z_pro;
      
      function get_nx_pro 
        extends get_z_pro;
        annotation (partialderivative(x));
      end get_nx_pro;
      
      function get_ny_pro 
        extends get_z_pro;
        annotation (partialderivative(y));
      end get_ny_pro;
      
    end Road;
    
    model Industrial_Area_9 
        Graphics.testSurf testSurf7(
        PNG=7,
        offset_x=-131.81,
        offset_y=-131.81)  annotation (extent=[10,12; 30,32]);
        Graphics.testSurf testSurf8(
        PNG=8,
        offset_x=-40.905,
        offset_y=-131.81)  annotation (extent=[-10,12; 10,32]);
        Graphics.testSurf testSurf9(
        PNG=9,
        offset_y=-131.81,
        offset_x=50)       annotation (extent=[-30,12; -10,32]);
        Graphics.testSurf testSurf6(
        PNG=6,
        offset_y=-40.905,
        offset_x=50)       annotation (extent=[-30,-8; -10,12]);
        Graphics.testSurf testSurf5(
        PNG=5,
        offset_x=-40.905,
        offset_y=-40.905)  annotation (extent=[-10,-8; 10,12]);
        Graphics.testSurf testSurf4(
          PNG=4,
        offset_y=-40.905,
        offset_x=-131.81)  annotation (extent=[10,-8; 30,12]);
        Graphics.testSurf testSurf1(
        PNG=1,
        offset_x=-131.81,
        offset_y=50)       annotation (extent=[10,-28; 30,-8]);
        Graphics.testSurf testSurf2(
        PNG=2,
        offset_y=50,
        offset_x=-40.905)  annotation (extent=[-10,-28; 10,-8]);
        Graphics.testSurf testSurf3(
        PNG=3,
        offset_x=50,
        offset_y=50)       annotation (extent=[-30,-28; -10,-8]);
    end Industrial_Area_9;
    
    model Industrial_Area_16 
      
    parameter Real d_x=-120;
    parameter Real d_y=275;
        Graphics.testSurf s_9(
        PNG=9,
        offset_x=-131.81 + d_x,
        offset_y=-131.81 + d_y) 
                           annotation (extent=[10,12; 30,32]);
        Graphics.testSurf s_10(
        PNG=10,
        offset_x=-40.905 + d_x,
        offset_y=-131.81 + d_y) 
                           annotation (extent=[-10,12; 10,32]);
        Graphics.testSurf s_11(
        PNG=11,
        offset_x=50 + d_x,
        offset_y=-131.81 + d_y) 
                           annotation (extent=[-30,12; -10,32]);
        Graphics.testSurf s_7(
        PNG=7,
        offset_x=50 + d_x,
        offset_y=-40.905 + d_y) 
                           annotation (extent=[-30,-8; -10,12]);
        Graphics.testSurf s_6(
        PNG=6,
        offset_x=-40.905 + d_x,
        offset_y=-40.905 + d_y) 
                           annotation (extent=[-10,-8; 10,12]);
        Graphics.testSurf s_5(
        PNG=5,
        offset_x=-131.81 + d_x,
        offset_y=-40.905 + d_y) 
                           annotation (extent=[10,-8; 30,12]);
        Graphics.testSurf s_1(
        PNG=1,
        offset_x=-131.81 + d_x,
        offset_y=50 + d_y) annotation (extent=[10,-28; 30,-8]);
        Graphics.testSurf s_2(
        PNG=2,
        offset_x=-40.905 + d_x,
        offset_y=50 + d_y) annotation (extent=[-10,-28; 10,-8]);
        Graphics.testSurf s_3(
        PNG=3,
        offset_x=50 + d_x,
        offset_y=50 + d_y) annotation (extent=[-30,-28; -10,-8]);
        Graphics.testSurf s_4(
        PNG=4,
        offset_x=140.905 + d_x,
        offset_y=50 + d_y) annotation (extent=[-50,-28; -30,-8]);
        Graphics.testSurf s_8(
        PNG=8,
        offset_x=140.905 + d_x,
        offset_y=-40.905 + d_y) 
                           annotation (extent=[-50,-8; -30,12]);
        Graphics.testSurf s_12(
        PNG=12,
        offset_x=140.905 + d_x,
        offset_y=-131.81 + d_y) 
                           annotation (extent=[-50,12; -30,32]);
        Graphics.testSurf s_13(
        PNG=13,
        offset_x=-131.81 + d_x,
        offset_y=-222.715 + d_y) 
                           annotation (extent=[10,32; 30,52]);
        Graphics.testSurf s_14(
        PNG=14,
        offset_x=-40.905 + d_x,
        offset_y=-222.715 + d_y) 
                           annotation (extent=[-10,32; 10,52]);
        Graphics.testSurf s_15(
        PNG=15,
        offset_x=50 + d_x,
        offset_y=-222.715 + d_y) 
                           annotation (extent=[-30,32; -10,52]);
        Graphics.testSurf s_16(
        PNG=16,
        offset_x=140.905 + d_x,
        offset_y=-222.715 + d_y) 
                           annotation (extent=[-50,32; -30,52]);
    end Industrial_Area_16;
    
    model Drag_Area 
      
    parameter Real d_x=-120;
    parameter Real d_y=275;
        Graphics.Flat_Surface s_90(
        offset_x=-131.81 + d_x,
        offset_y=-131.81 + d_y,
        PNG=98)            annotation (extent=[-20,0; 0,20]);
        Graphics.Flat_Surface s_91(
        offset_x=-40.905 + d_x,
        offset_y=-131.81 + d_y,
        PNG=98)            annotation (extent=[-40,0; -20,20]);
        Graphics.Flat_Surface s_92(
        offset_x=50 + d_x,
        offset_y=-131.81 + d_y,
        PNG=98)            annotation (extent=[-60,0; -40,20]);
        Graphics.Flat_Surface s_86(
        offset_x=50 + d_x,
        offset_y=-40.905 + d_y,
        PNG=99)            annotation (extent=[-60,-20; -40,0]);
        Graphics.Flat_Surface s_85(
        offset_x=-40.905 + d_x,
        offset_y=-40.905 + d_y,
        PNG=99)            annotation (extent=[-40,-20; -20,0]);
        Graphics.Flat_Surface s_84(
        offset_x=-131.81 + d_x,
        offset_y=-40.905 + d_y,
        PNG=99)            annotation (extent=[-20,-20; 0,0]);
        Graphics.Flat_Surface s_87(
        offset_x=140.905 + d_x,
        offset_y=-40.905 + d_y,
        PNG=99)            annotation (extent=[-80,-20; -60,0]);
        Graphics.Flat_Surface s_93(
        offset_x=140.905 + d_x,
        offset_y=-131.81 + d_y,
        PNG=98)            annotation (extent=[-80,0; -60,20]);
        Graphics.Flat_Surface s_96(
        offset_x=-131.81 + d_x,
        offset_y=-222.715 + d_y,
        PNG=99)            annotation (extent=[-20,20; 0,40]);
        Graphics.Flat_Surface s_97(
        offset_x=-40.905 + d_x,
        offset_y=-222.715 + d_y,
        PNG=99)            annotation (extent=[-40,20; -20,40]);
        Graphics.Flat_Surface s_98(
        offset_x=50 + d_x,
        offset_y=-222.715 + d_y,
        PNG=99)            annotation (extent=[-60,20; -40,40]);
        Graphics.Flat_Surface s_99(
        offset_x=140.905 + d_x,
        offset_y=-222.715 + d_y,
        PNG=99)            annotation (extent=[-80,20; -60,40]);
        Graphics.Flat_Surface s_89(
        offset_y=-131.81 + d_y,
        offset_x=-222.715 + d_x,
        PNG=98)            annotation (extent=[0,0; 20,20]);
        Graphics.Flat_Surface s_83(
        offset_y=-40.905 + d_y,
        offset_x=-222.715 + d_x,
        PNG=99)            annotation (extent=[0,-20; 20,0]);
        Graphics.Flat_Surface s_95(
        offset_y=-222.715 + d_y,
        offset_x=-222.715 + d_x,
        PNG=99)            annotation (extent=[0,20; 20,40]);
        Graphics.Flat_Surface s_88(
        offset_y=-131.81 + d_y,
        offset_x=-313.62 + d_x,
        PNG=98)            annotation (extent=[20,0; 40,20]);
        Graphics.Flat_Surface s_82(
        offset_y=-40.905 + d_y,
        offset_x=-313.62 + d_x,
        PNG=99)            annotation (extent=[20,-20; 40,0]);
        Graphics.Flat_Surface s_94(
        offset_y=-222.715 + d_y,
        offset_x=-313.62 + d_x,
        PNG=99)            annotation (extent=[20,20; 40,40]);
        Graphics.Flat_Surface s_1(
        offset_y=-131.81 + d_y,
        PNG=98,
        offset_x=-404.525 + d_x) 
                           annotation (extent=[40,0; 60,20]);
        Graphics.Flat_Surface s_2(
        offset_y=-40.905 + d_y,
        PNG=99,
        offset_x=-404.525 + d_x) 
                           annotation (extent=[40,-20; 60,0]);
        Graphics.Flat_Surface s_3(
        offset_y=-222.715 + d_y,
        PNG=99,
        offset_x=-404.525 + d_x) 
                           annotation (extent=[40,20; 60,40]);
        Graphics.Flat_Surface s_4(
        offset_y=-40.905 + d_y,
        PNG=99,
        offset_x=-495.43 + d_x) 
                           annotation (extent=[60,-20; 80,0]);
        Graphics.Flat_Surface s_5(
        offset_y=-131.81 + d_y,
        PNG=98,
        offset_x=-495.43 + d_x) 
                           annotation (extent=[60,0; 80,20]);
        Graphics.Flat_Surface s_6(
        offset_y=-222.715 + d_y,
        PNG=99,
        offset_x=-495.43 + d_x) 
                           annotation (extent=[60,20; 80,40]);
    end Drag_Area;
  end Environments;
  
  package Aerodynamics 
    "This class contains the model of aerodynamic resistance" 
    model Aerodynamics 
      import Modelica.Mechanics.MultiBody.Frames.*;
      parameter Real C_x_A_drag=0.32;
      parameter Real C_x_A_lift=0.06;
      //parameter Modelica.SIunits.Velocity v_wind[3]={0,0,0};
      parameter Modelica.SIunits.Density rho = 1.167;
      //Orientation terna;
      Modelica.SIunits.Velocity v_tot[3];
      //Real x[3];
      //Real z[3];
      Real forze[3];
      
    protected 
      outer MotorcycleDynamics.Environments.Road road;
      annotation (
        Coordsys(
          extent=[-100, -100; 100, 100],
          grid=[1, 1],
          component=[20, 20]),
        Icon,
        Window(
          x=0.45,
          y=0.01,
          width=0.35,
          height=0.49));
    public 
      Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a 
        annotation (extent=[-20,-100; 0,-80]);
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow Drag_Force(
        color={0,0,200},
        diameter=0.02,
        r=frame_a.r_0,
        r_head=0.005*forze[1]*resolve1(frame_a.R, {1,0,0})) 
                         annotation (extent=[-100,50; -80,70]);
      Modelica.Mechanics.MultiBody.Visualizers.Advanced.Arrow Lift_Force(
        color={0,0,200},
        diameter=0.02,
        r=frame_a.r_0,
        r_head=0.005*forze[3]*resolve1(frame_a.R, {0,0,1})) 
                         annotation (extent=[-100,20; -80,40]);
    equation 
      //x = normalize(cross(resolve1(frame_a.R, {0,1,0}),z));
      //z = normalize({-road.get_nx(frame_a.r_0[1], frame_a.r_0[2]),-road.get_ny(frame_a.r_0[1], frame_a.r_0[2]),1});
      
      //terna = from_nxz(x,z);
      v_tot = resolve2(frame_a.R, der(frame_a.r_0));// - v_wind);
      
      forze[1]=-(0.5*rho*C_x_A_drag*v_tot[1]^2);
      forze[2]=0;
      forze[3]=0.5*rho*C_x_A_lift*v_tot[1]^2;
      
      zeros(3) = frame_a.f + forze;//resolve2(frame_a.R, resolve1(terna, forze));
      zeros(3) = frame_a.t;
    end Aerodynamics;
  end Aerodynamics;
  
  package Graphics 
    model VisualBase 
      //constant Real VisualObject = 987000;
      Real ObjectType;
      output Real Form = 987000 + ObjectType  annotation(Hide=false);
      annotation (
        Coordsys(extent=[-100, -100; 100, 100]));
    end VisualBase;
    
    model SurfaceMaterial 
      import VisualBase;
      extends VisualBase;
      output Real material annotation (Hide=false);
      output Real extra annotation (Hide=false);
      output Real NumberOfU annotation (Hide=false);
      output Real NumberOfV annotation (Hide=false);
      output Real x[nu, nv] annotation (Hide=false);
      output Real y[nu, nv] annotation (Hide=false);
      output Real z[nu, nv] annotation (Hide=false);
      parameter Integer nu=2;
      parameter Integer nv=2 "Number of points for u and v.";
      parameter Real Material[4]={1,0,0,0.5} "Color and specular coefficient.";
      parameter Real Extra=0.0 "Additional parameters.";
      annotation (Coordsys(extent=[-100, -100; 100, 100]));
    equation 
      ObjectType = 57;
      NumberOfU = nu;
      NumberOfV = nv;
      material = PackMaterial(Material[1], Material[2], Material[3], Material[4]);
      extra = Extra;
    end SurfaceMaterial;
    
    model testSurf 
      import SurfaceMaterial;
      parameter Real offset_x=0;
      parameter Real offset_y=0;
      parameter Real lenght_x=100;
      parameter Real lenght_y=100;
      parameter Real quote=0.01;
      parameter Real PNG=1;
      SurfaceMaterial surf(
        Material={1,1,1,1},
        nu=11,
        nv=11,
        Extra=10*(PNG + 10*100)) 
                               annotation (extent=[-20,20; 0,40]);
    equation 
      
        for i in 1:surf.nu loop
          for j in 1:surf.nv loop
            surf.x[i, j] = lenght_x*i/surf.nu-offset_x;
            surf.y[i, j] = lenght_y*j/surf.nv-offset_y;// + surf.x[i, j]/10;
            surf.z[i, j] = ((surf.x[i, j]/55)^2 - (surf.y[i, j]/50)^2)*1 + quote;//0.01;//0.1*Modelica.Math.sin(surf.x[i, j]*6);
          end for;
        end for;
      
      // for i in 1:surf.nu loop
      //   for j in 1:surf.nv loop
      //     surf.x[i, j] = lenght_x*i/surf.nu-offset_x;
      //     surf.y[i, j] = lenght_y*j/surf.nv-offset_y;// + surf.x[i, j]/10;
      //     surf.z[i, j] = quote;//0.1*Modelica.Math.sin(surf.x[i, j]*6);
      //   end for;
      //end for;
    //  surf1.x = surf.x - fill(1.1, surf.nu, surf.nv);
    //  surf1.y = surf.y;
    //  surf1.z = surf.z;
    end testSurf;
    
    model Flat_Surface 
      import SurfaceMaterial;
      parameter Real offset_x=0;
      parameter Real offset_y=0;
      parameter Real lenght_x=100;
      parameter Real lenght_y=100;
      parameter Real quote=0;
      parameter Real PNG=1;
      SurfaceMaterial surf(
        Material={1,1,1,1},
        nu=11,
        nv=11,
        Extra=10*(PNG + 10*100)) 
                               annotation (extent=[-20,20; 0,40]);
    equation 
      
        for i in 1:surf.nu loop
          for j in 1:surf.nv loop
            surf.x[i, j] = lenght_x*i/surf.nu-offset_x;
            surf.y[i, j] = lenght_y*j/surf.nv-offset_y;// + surf.x[i, j]/10;
            surf.z[i, j] = quote-0.01;//0.01;//0.1*Modelica.Math.sin(surf.x[i, j]*6);
          end for;
        end for;
      
      // for i in 1:surf.nu loop
      //   for j in 1:surf.nv loop
      //     surf.x[i, j] = lenght_x*i/surf.nu-offset_x;
      //     surf.y[i, j] = lenght_y*j/surf.nv-offset_y;// + surf.x[i, j]/10;
      //     surf.z[i, j] = quote;//0.1*Modelica.Math.sin(surf.x[i, j]*6);
      //   end for;
      //end for;
    //  surf1.x = surf.x - fill(1.1, surf.nu, surf.nv);
    //  surf1.y = surf.y;
    //  surf1.z = surf.z;
    end Flat_Surface;
  end Graphics;
  
  package Example 
    
  annotation (
  Documentation(info="<html>
<p> This package contain some example of motorcycle dynamics.
</HTML>"));
    
  model Supermotard 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=60,
          NumberOfIntervals=1200,
          Tolerance=1e-006));
    Motorcycle Supermotard(
        color={90,90,90},
        Rear_Wheel_data=Rear_Wheel_data,
        Front_Wheel_data=Front_Wheel_data,
        xyz_init={0.40,0,0.3331 + 0.01}) 
                             annotation (extent=[-40,-6; 18,50]);
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-100,-100; -80,-80]);
    inner Road road(
        d=0.01,
        choice=2,
        a=55,
        b=50) 
             annotation (extent=[46, -100; 100, -58]);
      parameter Wheel.Data.Supermotard_Front_Wheel_Data Front_Wheel_data(Radius=
           0.333, animation=true) 
        annotation (extent=[80,60; 100,80]);
      parameter Wheel.Data.Supermotard_Rear_Wheel_Data Rear_Wheel_data(Radius=
            0.33, animation=true) 
        annotation (extent=[40,60; 60,80]);
      inner Suspension.Front_Suspension.Data.Supermotard_Front_Suspension_Data 
        Front_Suspension_data(Steer_Stopper=50, Spring=[-0.1,-10000; -0.06,-1055.394;
            -0.05,-389.309; 0,10.666; 0.048,394.642; 0.054,490.636; 0.06,
            1119.3967; 0.1,10000]) 
                              annotation (extent=[80,80; 100,100]);
      inner Suspension.Rear_Suspension.Data.Supermotard_Rear_Suspension_Data 
        Rear_Suspension_data(s_unstretched=0.25, Spring=[-0.03,-1000000; -0.025,
            -66580.77; -0.01,-29928.77; 0,59.23; 0.019,29047.63; 0.022,41492.65;
            0.025,96204.09; 0.03,1000000]) 
                             annotation (extent=[40,80; 60,100]);
      inner Supermotard_Dimension_MassPosition_Data Dimension_MassPosition_data
        annotation (extent=[60,80; 80,100]);
      inner Chassis.Data.Supermotard_Chassis_Data Chassis_data 
        annotation (extent=[60,60; 80,80]);
      inner Rear_Swinging_Arm.Data.Supermotard_Rear_Swinging_Arm_Data 
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Modelica.Blocks.Sources.TimeTable TT "Thottle Table" 
        annotation (extent=[-100,-4; -86,8],   rotation=0);
      Modelica.Blocks.Continuous.TransferFunction DD(a={1/8,1}) 
        "Driver_Dynamic" 
        annotation (extent=[-24,-100; -8,-86]);
      Braking_System.ABS ABS_F(Hz=10, best_slip=0.11) 
                      annotation (extent=[0,-100; 16,-84]);
      Environments.Industrial_Area_16 Industrial_Area1 
        annotation (extent=[26,-100; 46,-80]);
      Driver.Joystick_Driver Joystick_Driver1 
        annotation (extent=[-44,58; -24,78]);
      Modelica.Mechanics.Rotational.Torque Torque2 
        annotation (extent=[-72,-6; -58,4],   rotation=0);
      Modelica.Blocks.Sources.TimeTable FBT(table=[0,0; 3.4,0; 3.5,1; 4.1,1;
            4.2,0; 37.3,0; 37.4,1; 38.0,1; 38.1,0; 41.4,0; 41.5,1; 41.9,1; 42.0,
            0; 50.9,0; 51,1; 51.2,1; 51.3,0; 100,0]) "Front Brake Table" 
        annotation (extent=[-46,-100; -32,-86]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Modelica.Blocks.Sources.Constant Constant1(k=0) 
        annotation (extent=[-82,-68; -62,-48]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model annotation (extent=[-48,-46; -28,-26]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1 annotation (extent=[42,-40; 62,-20]);
  equation 
      connect(Joystick_Driver1.frame_Seaddle, Supermotard.frame_Saddle1) annotation (
          points=[-35,59; -35,43.5; -17.09,43.5; -17.09,25.64], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Supermotard.Sensor, Joystick_Driver1.Sensor1) annotation (points=[-48.41,
            -2.92; -70,-2.92; -70,66; -43,66; -43,67],     style(color=74,
            rgbcolor={0,0,127}));
      connect(Joystick_Driver1.flange_steering, Supermotard.Steering) 
        annotation (points=[-25,71; 26.41,71; 26.41,48.04], style(color=0,
            rgbcolor={0,0,0}));
      connect(ABS_F.to_Brake, Supermotard.Front_Brake1) annotation (points=[15.2,
            -91.2; 24,-91.2; 24,-44; 92,-44; 92,24; 20.9,24; 20.9,47.76],
          style(color=74, rgbcolor={0,0,127}));
      connect(ABS_F.Slip, Supermotard.Pin2) annotation (points=[0.8,-84.8; 0.8,
            -70; 14,-70; 14,2.4; 27.86,2.4],       style(color=3, rgbcolor={0,0,
              255}));
      connect(DD.y, ABS_F.u) annotation (points=[-7.2,-93; -6,-93; -6,-91.2;
            0.8,-91.2], style(color=74, rgbcolor={0,0,127}));
      connect(FBT.y, DD.u) annotation (points=[-31.3,-93; -25.6,-93], style(
            color=74, rgbcolor={0,0,127}));
      connect(Torque2.flange_b, Supermotard.Rear_Joint) annotation (points=[-58,-1;
            -54.365,-1; -54.365,9.4; -50.73,9.4],         style(color=0,
            rgbcolor={0,0,0}));
      connect(TT.y, Torque2.tau) annotation (points=[-85.3,2; -78,2; -78,-1;
            -73.4,-1], style(color=74, rgbcolor={0,0,127}));
      connect(Aerodynamics1.frame_a, Supermotard.Pressure_center) annotation (
          points=[-11,81; -11,61.5; 2.92,61.5; 2.92,41.04], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Constant1.y, Supermotard.Rear_Brake1) annotation (points=[-61,-58;
            -8.68,-58; -8.68,4.08], style(color=74, rgbcolor={0,0,127}));
      connect(pacejka_Friction_Model.Pin, Supermotard.Pin1) annotation (points=[-38,-27;
            -38,-23.5; -38,-3.2; -45.8,-3.2],          style(color=3, rgbcolor=
              {0,0,255}));
      connect(pacejka_Friction_Model1.Pin, Supermotard.Pin2) annotation (points=[52,-21;
            52,-16.58; 52,2.4; 27.86,2.4],               style(color=3,
            rgbcolor={0,0,255}));
  end Supermotard;
  annotation (uses(VehicleDynamics(version="0.8.1"), Modelica(version="2.2")),
                                         Commands(file=
          "C:/Documents and Settings/Filippo.FILIPPO-3Y2QADL/Desktop/prova.mos" "prova",
                 file=
          "C:/Documents and Settings/Filippo.FILIPPO-3Y2QADL/Desktop/Provqa.mos" "Provqa",
      file="a.mos" "a"),
    version="1",
    conversion(from(version="", script="ConvertFromRegins_.mos")));
    
  model Supermotard_GP 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=130,
          NumberOfIntervals=2600,
          Tolerance=1e-006));
    Motorcycle Supermotard(
        color={90,90,90},
        Rear_Wheel_data=Rear_Wheel_data,
        Front_Wheel_data=Front_Wheel_data,
        xyz_init={0.40,0,0.3331 + 0.01}) 
                             annotation (extent=[-40,-6; 18,50]);
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-100,-100; -80,-80]);
    inner Road road(
        d=0.01,
        choice=2,
        a=55,
        b=50) 
             annotation (extent=[46, -100; 100, -58]);
      parameter Wheel.Data.Supermotard_Front_Wheel_Data Front_Wheel_data(Radius=
           0.333, animation=true) 
        annotation (extent=[80,60; 100,80]);
      parameter Wheel.Data.Supermotard_Rear_Wheel_Data Rear_Wheel_data(Radius=
            0.33, animation=true) 
        annotation (extent=[40,60; 60,80]);
      inner Suspension.Front_Suspension.Data.Supermotard_Front_Suspension_Data 
        Front_Suspension_data(Steer_Stopper=50, Spring=[-0.1,-10000; -0.06,-1055.394;
            -0.05,-389.309; 0,10.666; 0.048,394.642; 0.054,490.636; 0.06,
            1119.3967; 0.1,10000]) 
                              annotation (extent=[80,80; 100,100]);
      inner Suspension.Rear_Suspension.Data.Supermotard_Rear_Suspension_Data 
        Rear_Suspension_data(s_unstretched=0.25, Spring=[-0.03,-1000000; -0.025,
            -66580.77; -0.01,-29928.77; 0,59.23; 0.019,29047.63; 0.022,41492.65;
            0.025,96204.09; 0.03,1000000]) 
                             annotation (extent=[40,80; 60,100]);
      inner Supermotard_Dimension_MassPosition_Data Dimension_MassPosition_data
        annotation (extent=[60,80; 80,100]);
      inner Chassis.Data.Supermotard_Chassis_Data Chassis_data 
        annotation (extent=[60,60; 80,80]);
      inner Rear_Swinging_Arm.Data.Supermotard_Rear_Swinging_Arm_Data 
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Modelica.Blocks.Sources.TimeTable TT(table=[0,0; 0.05,0; 0.28,-650; 3.35,
            -650; 3.36,0; 6.6,0; 12,0; 12.1,-10; 16,-30; 21,-130; 25,-100; 25.5,
            -250; 27,-20; 28,-200; 30,-150; 34,-150; 35,-170; 37,-40; 40,-10;
            47,-20; 50,-40; 52,-60; 58,-100; 59,-88; 61,-152; 62,-100; 64.1,0;
            65,0; 66.1,0; 67,0; 68,-60; 69,-80; 69.1,0; 72,0; 76,-50; 80,-10;
            81.9,0; 86,0; 87.4,-90; 88,-15; 89.4,-30; 89.5,-100; 95,-507; 95.11,
            0; 95.21,0; 98,0; 99,0; 100,-30; 103,-880; 103.2,0; 103.65,-500;
            105,-400; 105.8,0; 109,-30; 113.4,-30; 113.79,-570; 113.99,0; 116,0;
            119,0; 120,-60; 125,-110; 125.1,0; 130,0]) "Thottle Table" 
        annotation (extent=[-102,-4; -88,8],   rotation=0);
      Modelica.Blocks.Continuous.TransferFunction DD(a={1/8,1}) 
        "Driver_Dynamic" 
        annotation (extent=[-24,-100; -8,-86]);
      Braking_System.ABS ABS_F(Hz=10, best_slip=0.11) 
                      annotation (extent=[0,-100; 16,-84]);
      Modelica.Blocks.Sources.TimeTable ST(table=[0,0; 1,0; 2,-3; 4.1,0; 4.15,
            22; 5.8,14; 7,2; 8.7,0; 8.8,-21; 10.8,-8; 11,-1; 12.3,-8; 13.5,-3;
            15.8,4; 15.9,0; 17,5; 18.5,0; 18.6,-16; 20.4,-8; 23,7.6; 26.5,-3.8;
            27,-10; 27.5,-8; 29.0,-2; 30.6,0; 32.5,0; 32.6,-9; 33.1,-10; 36.6,-9.5;
            37.7,7; 37.8,0; 38.0,-3; 38.1,-18; 39.3,-12; 40.6,-7; 40.7,0; 42.0,
            0; 42.1,19; 42.4,14; 43,12; 43.8,8; 44.2,-15; 47.8,-9; 48.4,23;
            50.2,5; 50.5,-23; 50.9,-17; 52,-12; 53.5,-10; 54,-8.8; 54.1,0; 58.6,
            0; 60.1,10; 61.6,5; 61.7,-2; 64,-8; 65,5; 66,10; 67,12; 68,9; 69,0;
            70.0,0; 70.1,15; 73,9; 73.2,4; 73.5,-12; 76.4,-3; 77,-16; 78.7,-12;
            78.9,28; 79.3,13; 81.7,7; 81.9,4; 81.95,-31; 82.8,-21; 83.2,-11; 84,
            -12; 84.8,-7; 84.9,8; 85.0,6; 85.2,29; 85.5,18; 86,10; 86.6,-10;
            86.7,-9; 87,-8; 87.4,-4; 88,-10; 88.05,46; 88.4,15.5; 89,10; 90,-4;
            90.5,0; 91,-6; 92.5,-7; 95,-2; 95.33,20; 95.5,0; 100,0]) 
        "Steer Table" 
        annotation (extent=[80,46; 94,56],  rotation=180);
      Environments.Industrial_Area_16 Industrial_Area1 
        annotation (extent=[26,-100; 46,-80]);
      Driver.Joystick_Driver Joystick_Driver1 
        annotation (extent=[-44,58; -24,78]);
      Modelica.Mechanics.Rotational.Torque Torque1 
        annotation (extent=[42,40; 56,54], rotation=180);
      Modelica.Mechanics.Rotational.Torque Torque2 
        annotation (extent=[-72,-6; -58,4],   rotation=0);
      Braking_System.ABS ABS2(                Hz=10, best_slip=0.11) 
                      annotation (extent=[-22,-66; -8,-52]);
      Modelica.Blocks.Sources.TimeTable RBT(table=[0,0; 3.5,0; 3.7,1; 4.1,1;
            4.4,0; 64.8,0; 64.9,1; 65.4,1; 65.5,0; 69.1,0; 69.2,1; 69.8,1; 69.9,
            0; 85.05,0; 85.1,1; 85.38,1; 85.4,0; 95.2,0; 95.3,1; 95.8,1; 95.9,0;
            105.4,0; 105.41,1; 106.8,1; 106.85,0; 120,0]) "Rear Brake Table" 
        annotation (extent=[-80,-66; -66,-52]);
      Modelica.Blocks.Continuous.TransferFunction DD1(a={1/8,1}) 
        "Driver_Dynamic" 
        annotation (extent=[-50,-66; -34,-52]);
      Modelica.Blocks.Sources.TimeTable FBT(table=[0,0; 3.4,0; 3.5,1; 4.1,1;
            4.2,0; 37.3,0; 37.4,1; 38.0,1; 38.1,0; 41.4,0; 41.5,1; 41.9,1; 42.0,
            0; 50.9,0; 51,1; 51.2,1; 51.3,0; 64.8,0; 64.9,1; 65.4,1; 65.5,0;
            69.1,0; 69.2,1; 68.9,1; 69.9,0; 85.1,0; 85.15,1; 85.55,1; 85.551,0;
            95.21*0 + 95.11,0; 95.3*0 + 95.2,1; 95.7,1; 95.8,0; 105.4,0; 105.41,
            1; 106.8,1; 106.85,0; 125.1,0; 125.29,1; 126.35,0.34; 127,0.1 + 0;
            127.1,1; 127.2,1; 127.4,0; 130,0]) "Front Brake Table" 
        annotation (extent=[-48,-100; -34,-86]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Modelica.Blocks.Sources.TimeTable ST1(table=[0,0; 95.3,0; 95.5,24; 96.3,
            18; 97,12; 97.5,9.5; 98,8.5; 99,7.5; 99.5,-10; 100,-5; 102,0; 106.1,
            0; 106.5,29; 109,-14; 110,-7; 111,-12; 112,-10; 113,-7; 113.4,-8;
            113.6,20; 114.5,-10; 115,-5; 115.1,-30; 115.5,-15; 116,-10; 117,-5;
            118,14; 119,0; 127.8,0; 128,-5; 128.2,0; 130,0]) "Steer Table" 
        annotation (extent=[78,30; 92,40],  rotation=180);
      Modelica.Blocks.Math.Add Add1 
        annotation (extent=[62,44; 72,54], rotation=180);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model annotation (extent=[-58,-42; -38,-22]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1 annotation (extent=[18,-40; 38,-20]);
  equation 
      connect(Joystick_Driver1.frame_Seaddle, Supermotard.frame_Saddle1) annotation (
          points=[-35,59; -35,43.5; -17.09,43.5; -17.09,25.64], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Supermotard.Sensor, Joystick_Driver1.Sensor1) annotation (points=[-48.41,
            -2.92; -70,-2.92; -70,66; -43,66; -43,67],     style(color=74,
            rgbcolor={0,0,127}));
      connect(Joystick_Driver1.flange_steering, Supermotard.Steering) 
        annotation (points=[-25,71; 26.41,71; 26.41,48.04], style(color=0,
            rgbcolor={0,0,0}));
      connect(Supermotard.Steering, Torque1.flange_b) annotation (points=[26.41,
            48.04; 35.205,48.04; 35.205,47; 42,47], style(color=0, rgbcolor={0,
              0,0}));
      connect(ABS_F.to_Brake, Supermotard.Front_Brake1) annotation (points=[15.2,
            -91.2; 24,-91.2; 24,-44; 92,-44; 92,24; 20.9,24; 20.9,47.76],
          style(color=74, rgbcolor={0,0,127}));
      connect(ABS_F.Slip, Supermotard.Pin2) annotation (points=[0.8,-84.8; 0.8,
            -70; 14,-70; 14,2.4; 27.86,2.4],       style(color=3, rgbcolor={0,0,
              255}));
      connect(ABS2.to_Brake, Supermotard.Rear_Brake1) annotation (points=[-8.7,
            -58.3; 6,-58.3; 6,-10; -18,-10; -18,4.08; -8.68,4.08], style(color=
              74, rgbcolor={0,0,127}));
      connect(DD.y, ABS_F.u) annotation (points=[-7.2,-93; -6,-93; -6,-91.2;
            0.8,-91.2], style(color=74, rgbcolor={0,0,127}));
      connect(DD1.y, ABS2.u) annotation (points=[-33.2,-59; -28.6,-59; -28.6,
            -58.3; -21.3,-58.3], style(color=74, rgbcolor={0,0,127}));
      connect(RBT.y, DD1.u) annotation (points=[-65.3,-59; -51.6,-59], style(
            color=74, rgbcolor={0,0,127}));
      connect(FBT.y, DD.u) annotation (points=[-33.3,-93; -25.6,-93], style(
            color=74, rgbcolor={0,0,127}));
      connect(Supermotard.Pin1, ABS2.Slip) annotation (points=[-45.8,-3.2; 0,
            -3.2; 0,-50; -21.3,-50; -21.3,-52.7],style(color=3, rgbcolor={0,0,
              255}));
      connect(Torque2.flange_b, Supermotard.Rear_Joint) annotation (points=[-58,-1;
            -54.365,-1; -54.365,9.4; -50.73,9.4],         style(color=0,
            rgbcolor={0,0,0}));
      connect(TT.y, Torque2.tau) annotation (points=[-87.3,2; -78,2; -78,-1;
            -73.4,-1], style(color=74, rgbcolor={0,0,127}));
      connect(Aerodynamics1.frame_a, Supermotard.Pressure_center) annotation (
          points=[-11,81; -11,61.5; 2.92,61.5; 2.92,41.04], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Torque1.tau, Add1.y) annotation (points=[57.4,47; 60.7,47; 60.7,
            49; 61.5,49], style(color=74, rgbcolor={0,0,127}));
      connect(Add1.u2, ST.y) annotation (points=[73,52; 76,52; 76,51; 79.3,51],
          style(color=74, rgbcolor={0,0,127}));
      connect(Add1.u1, ST1.y) annotation (points=[73,46; 76,46; 76,35; 77.3,35],
          style(color=74, rgbcolor={0,0,127}));
      connect(pacejka_Friction_Model1.Pin, Supermotard.Pin2) annotation (points=
           [28,-21; 28,-9.3; 28,2.4; 27.86,2.4], style(color=3, rgbcolor={0,0,
              255}));
      connect(Supermotard.Pin1, pacejka_Friction_Model.Pin) annotation (points=
            [-45.8,-3.2; -45.8,-13.6; -48,-13.6; -48,-23], style(color=3,
            rgbcolor={0,0,255}));
  end Supermotard_GP;
    
  model Supermotard_2_Moto 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=60,
          NumberOfIntervals=1200,
          Tolerance=1e-006));
    Motorcycle Supermotard(
        Rear_Wheel_data=Rear_Wheel_data,
        Front_Wheel_data=Front_Wheel_data,
      xyz_init=xyz_init,
      color=color)           annotation (extent=[-40,-6; 18,50]);
    inner Road road(
        a=55,
        b=50,
        choice=0,
        d=0) annotation (extent=[46, -100; 100, -58]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        Rear_Pacejka_Friction_Model(
          Fz0=855) 
                 annotation (extent=[-72,-42; -4,-30]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        Front_Pacejka_Friction_Model(
          Fz0=1000,
        Cy=0.83266,
        pdy1=1.3,
        pdy2=0,
        pdy3=0,
        pey1=-1.2556,
        pey2=-3.2068,
        pey4=-3.9975,
        pky1=22.841,
        pky2=2.1578,
        pky3=2.5058,
        pky4=-0.08088,
        Cgamma=0.867565,
        pky5=-0.22882,
        pky6=0.69677,
        pky7=-0.03077,
        Egamma=-15.815) 
                  annotation (extent=[18,-36; 86,-24]);
        Wheel.Data.Supermotard_Front_Wheel_Data Front_Wheel_data(Radius=
           0.333, animation=true) 
        annotation (extent=[80,60; 100,80]);
        Wheel.Data.Supermotard_Rear_Wheel_Data Rear_Wheel_data(Radius=
            0.33, animation=true) 
        annotation (extent=[40,60; 60,80]);
      inner Suspension.Front_Suspension.Data.Supermotard_Front_Suspension_Data 
        Front_Suspension_data(Steer_Stopper=50, Spring=[-0.1,-10000; -0.06,-1055.394;
            -0.05,-389.309; 0,10.666; 0.048,394.642; 0.054,490.636; 0.06,
            1119.3967; 0.1,10000],
      color=color)            annotation (extent=[80,80; 100,100]);
      inner Suspension.Rear_Suspension.Data.Supermotard_Rear_Suspension_Data 
        Rear_Suspension_data(s_unstretched=0.25, Spring=[-0.03,-1000000; -0.025,
            -66580.77; -0.01,-29928.77; 0,59.23; 0.019,29047.63; 0.022,41492.65;
            0.025,96204.09; 0.03,1000000]) 
                             annotation (extent=[40,80; 60,100]);
      inner Supermotard_Dimension_MassPosition_Data Dimension_MassPosition_data
        annotation (extent=[60,80; 80,100]);
      inner Chassis.Data.Supermotard_Chassis_Data Chassis_data(color=color) 
        annotation (extent=[60,60; 80,80]);
      inner Rear_Swinging_Arm.Data.Supermotard_Rear_Swinging_Arm_Data 
        Rear_Swinging_Arm_data(
                             color=color) 
                               annotation (extent=[20,80; 40,100]);
      Modelica.Blocks.Continuous.TransferFunction DD(a={1/8,1}) 
        "Driver_Dynamic" 
        annotation (extent=[-24,-100; -8,-86]);
      Braking_System.ABS ABS_F(best_slip=front_best_slip, Hz=Front_Brake_Dynamics) 
                      annotation (extent=[0,-100; 16,-84]);
      Driver.Joystick_Driver Joystick_Driver1 
        annotation (extent=[-44,58; -24,78]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Braking_System.ABS ABS_F1(best_slip=rear_best_slip, Hz=Rear_Brake_Dynamics) 
                      annotation (extent=[-58,-70; -42,-54]);
      Modelica.Blocks.Continuous.TransferFunction DD1(
                                                     a={1/8,1}) 
        "Driver_Dynamic" 
        annotation (extent=[-82,-70; -66,-56]);
    Modelica.Blocks.Interfaces.RealInput Rear_Brake 
      annotation (extent=[-110,-72; -90,-52]);
    Modelica.Blocks.Interfaces.RealInput Front_Brake 
      annotation (extent=[-110,-100; -90,-80]);
    parameter Real rear_best_slip=0.11;
    parameter Real Rear_Brake_Dynamics=10;
    parameter Real front_best_slip=0.11;
    parameter Real Front_Brake_Dynamics=10;
    parameter Real xyz_init[3]={0.40,0,0.3300000001};
    parameter Modelica.Mechanics.MultiBody.Types.Color color={90,90,90};
      Modelica.Blocks.Interfaces.RealInput Rear_Torque 
        annotation (extent=[-110,-12; -90,8]);
      Modelica.Mechanics.MultiBody.Forces.WorldTorque WorldTorque1 
        annotation (extent=[-76,-24; -56,-4]);
      Modelica.Blocks.Routing.Multiplex3 Multiplex3_1 
        annotation (extent=[-102,-42; -82,-22], rotation=0);
      Modelica.Blocks.Sources.Constant Constant1(k=0) 
        annotation (extent=[-106,22; -86,42], rotation=180);
  equation 
      connect(Joystick_Driver1.frame_Seaddle, Supermotard.frame_Saddle1) annotation (
          points=[-35,59; -35,43.5; -17.09,43.5; -17.09,25.64], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Supermotard.Sensor, Joystick_Driver1.Sensor1) annotation (points=[-61.75,
            -11.32; -70,-11.32; -70,66; -43,66; -43,67],   style(color=74,
            rgbcolor={0,0,127}));
      connect(Joystick_Driver1.flange_steering, Supermotard.Steering) 
        annotation (points=[-25,71; 26.41,71; 26.41,48.04], style(color=0,
            rgbcolor={0,0,0}));
      connect(ABS_F.to_Brake, Supermotard.Front_Brake1) annotation (points=[15.2,
            -91.2; 24,-91.2; 24,-44; 92,-44; 92,24; 20.9,24; 20.9,47.76],
          style(color=74, rgbcolor={0,0,127}));
      connect(ABS_F.Slip, Supermotard.Pin2) annotation (points=[0.8,-84.8; 0.8,
            -70; 14,-70; 14,-8.8; 50.48,-8.8],     style(color=3, rgbcolor={0,0,
              255}));
      connect(DD.y, ABS_F.u) annotation (points=[-7.2,-93; -6,-93; -6,-91.2; 
            0.8,-91.2], style(color=74, rgbcolor={0,0,127}));
      connect(Aerodynamics1.frame_a, Supermotard.Pressure_center) annotation (
          points=[-11,81; -11,61.5; 2.92,61.5; 2.92,41.04], style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Supermotard.Pin2, Front_Pacejka_Friction_Model.Pin) annotation (
          points=[50.48,-8.8; 50.48,-19.08; 52,-19.08; 52,-24.6],   style(color=
             3, rgbcolor={0,0,255}));
      connect(Supermotard.Pin1, Rear_Pacejka_Friction_Model.Pin) annotation (
          points=[-48.7,-18.32; -38,-18.32; -38,-30.6],
                                                   style(color=3, rgbcolor={0,0,
              255}));
    connect(ABS_F1.to_Brake, Supermotard.Rear_Brake1) annotation (points=[-42.8,
            -61.2; -38,-61.2; -38,-64; 0,-64; 0,6.88; -17.38,6.88],
                                                                 style(color=74,
          rgbcolor={0,0,127}));
    connect(DD1.y, ABS_F1.u) annotation (points=[-65.2,-63; -62.6,-63; -62.6,
          -61.2; -57.2,-61.2], style(color=74, rgbcolor={0,0,127}));
    connect(DD1.u, Rear_Brake) annotation (points=[-83.6,-63; -89.8,-63; -89.8,
          -62; -100,-62], style(color=74, rgbcolor={0,0,127}));
    connect(DD.u, Front_Brake) annotation (points=[-25.6,-93; -100,-93; -100,-90],
        style(color=74, rgbcolor={0,0,127}));
      connect(ABS_F1.Slip, Supermotard.Pin1) annotation (points=[-57.2,-54.8; 
            -57.2,-46; -2,-46; -2,-18.32; -48.7,-18.32],
                                                    style(color=3, rgbcolor={0,
              0,255}));
      connect(WorldTorque1.frame_b, Supermotard.frame_rear_hub1) annotation (
          points=[-56,-14; -56,6; -44.64,6; -44.64,2.4],  style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(Multiplex3_1.y, WorldTorque1.torque) annotation (points=[-81,-32;
            -78,-32; -78,-14], style(color=74, rgbcolor={0,0,127}));
      connect(Rear_Torque, Multiplex3_1.u2[1]) annotation (points=[-100,-2; -82,
            -2; -82,-12; -110,-12; -110,-32; -104,-32], style(color=74,
            rgbcolor={0,0,127}));
      connect(Constant1.y, Multiplex3_1.u1[1]) annotation (points=[-107,32;
            -116,32; -116,-22; -104,-22; -104,-25], style(color=74, rgbcolor={0,
              0,127}));
      connect(Constant1.y, Multiplex3_1.u3[1]) annotation (points=[-107,32;
            -114,32; -114,-39; -104,-39], style(color=74, rgbcolor={0,0,127}));
  end Supermotard_2_Moto;
    
    model Two_Motorcycle_Braking_Test 
      Supermotard_2_Moto Supermotard_ABS(xyz_init={0.40,1,0.33000001}) 
        annotation (extent=[-40,20; -20,40]);
      Environments.Drag_Area Drag_Area1(d_y=186.5, d_x=-100) 
        annotation (extent=[80,-100; 100,-80]);
      inner Modelica.Mechanics.MultiBody.World world(n={0,0,-1}, animateGravity=
           false) 
        annotation (extent=[-100,-100; -80,-80]);
      Modelica.Blocks.Sources.TimeTable TimeTable1(table=[0,0; 0.04,0; 0.046,328; 0.08,
            460; 0.415,480; 1.5,482.5; 2,482.1; 2.1,483; 5,482.28; 8,481.7; 10,
            480.4; 10.001,0; 20,0]) annotation (extent=[-100,40; -80,60]);
      annotation (Diagram,
        experiment(
          StopTime=15,
          NumberOfIntervals=2000,
          Tolerance=1e-006),
        experimentSetupOutput);
      Supermotard_2_Moto Supermotard_ABS1(
        rear_best_slip=1.1,
        front_best_slip=1.1,
        xyz_init={0.40,-1.5,0.33000001},
        color={255,107,36}) 
        annotation (extent=[0,20; 20,40]);
      Modelica.Blocks.Sources.Step Step1(height=1, startTime=10) 
        annotation (extent=[-102,-20; -82,0]);
      Modelica.Blocks.Sources.Constant Constant1(k=0) 
        annotation (extent=[-90,-62; -70,-42]);
    equation 
      connect(TimeTable1.y, Supermotard_ABS.Rear_Torque) annotation (points=[
            -79,50; -60,50; -60,29.8; -40,29.8], style(color=74, rgbcolor={0,0,
              127}));
      connect(TimeTable1.y, Supermotard_ABS1.Rear_Torque) annotation (points=[
            -79,50; -6,50; -6,29.8; 0,29.8], style(color=74, rgbcolor={0,0,127}));
      connect(Step1.y, Supermotard_ABS.Front_Brake) annotation (points=[-81,-10;
            -46,-10; -46,21; -40,21], style(color=74, rgbcolor={0,0,127}));
      connect(Supermotard_ABS1.Front_Brake, Step1.y) annotation (points=[0,21;
            -4,21; -4,-10; -81,-10], style(color=74, rgbcolor={0,0,127}));
      connect(Constant1.y, Supermotard_ABS.Rear_Brake) annotation (points=[-69,
            -52; -58,-52; -58,23.8; -40,23.8], style(color=74, rgbcolor={0,0,
              127}));
      connect(Constant1.y, Supermotard_ABS1.Rear_Brake) annotation (points=[-69,
            -52; -40,-52; -40,-46; -12,-46; -12,23.8; 0,23.8], style(color=74,
            rgbcolor={0,0,127}));
    end Two_Motorcycle_Braking_Test;
    
  model Supermotard_Test 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=130,
          Interval=0.01,
          Tolerance=1e-006),
      experimentSetupOutput(events=false));
    Motorcycle Supermotard(
        color={90,90,90},
        Rear_Wheel_data=Rear_Wheel_data,
        Front_Wheel_data=Front_Wheel_data,
        xyz_init={0.40,0,0.3331 + 0.01}) 
                             annotation (extent=[-52,-14; 6,42]);
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-102,-98; -82,-78]);
    inner Road road(
        d=0.01,
        a=55,
        b=50,
        choice=0) 
             annotation (extent=[46, -100; 100, -58]);
      parameter Wheel.Data.Supermotard_Front_Wheel_Data Front_Wheel_data(Radius=
           0.333, animation=true,
        ModelTyreRelaxation=true) 
        annotation (extent=[80,60; 100,80]);
      parameter Wheel.Data.Supermotard_Rear_Wheel_Data Rear_Wheel_data(Radius=
            0.33, animation=true,
        ModelTyreRelaxation=true) 
        annotation (extent=[40,60; 60,80]);
      inner Suspension.Front_Suspension.Data.Supermotard_Front_Suspension_Data 
        Front_Suspension_data(Steer_Stopper=50, Spring=[-0.1,-10000; -0.06,-1055.394;
            -0.05,-389.309; 0,10.666; 0.048,394.642; 0.054,490.636; 0.06,
            1119.3967; 0.1,10000]) 
                              annotation (extent=[80,80; 100,100]);
      inner Suspension.Rear_Suspension.Data.Supermotard_Rear_Suspension_Data 
        Rear_Suspension_data(s_unstretched=0.25, Spring=[-0.03,-1000000; -0.025,
            -66580.77; -0.01,-29928.77; 0,59.23; 0.019,29047.63; 0.022,41492.65;
            0.025,96204.09; 0.03,1000000]) 
                             annotation (extent=[40,80; 60,100]);
      inner Supermotard_Dimension_MassPosition_Data Dimension_MassPosition_data
        annotation (extent=[60,80; 80,100]);
      inner Chassis.Data.Supermotard_Chassis_Data Chassis_data 
        annotation (extent=[60,60; 80,80]);
      inner Rear_Swinging_Arm.Data.Supermotard_Rear_Swinging_Arm_Data 
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Modelica.Blocks.Continuous.TransferFunction DD(a={1/8,1}) 
        "Driver_Dynamic" 
        annotation (extent=[-24,-100; -8,-86]);
      Braking_System.ABS ABS_F(Hz=10, best_slip=0.11) 
                      annotation (extent=[0,-100; 16,-84]);
      Modelica.Mechanics.Rotational.Torque Torque2 
        annotation (extent=[-72,-6; -58,4],   rotation=0);
      Braking_System.ABS ABS2(                Hz=10, best_slip=0.11) 
                      annotation (extent=[-22,-66; -8,-52]);
      Modelica.Blocks.Continuous.TransferFunction DD1(a={1/8,1}) 
        "Driver_Dynamic" 
        annotation (extent=[-50,-66; -34,-52]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Wheel.Friction_Model.Pacejka.Data.Pacejka_120_70_ZR_17_Data 
        Pacejka_120_70_ZR_17_Data annotation (extent=[-80,80; -60,100]);
      Wheel.Friction_Model.Pacejka.Data.Pacejka_180_55_ZR_17_Data 
        Pacejka_180_55_ZR_17_Data annotation (extent=[-100,80; -80,100]);
      Modelica.Blocks.Sources.Constant const(k=0) 
        annotation (extent=[-92,-64; -72,-44]);
      Modelica.Blocks.Sources.TimeTable timeTable(table=[0,-10; 2,30; 4,-5; 6,-20;
            8,10])                  annotation (extent=[-132,-18; -112,2]);
      Driver.Joystick_Driver joystick_Driver 
        annotation (extent=[-48,42; -28,62]);
      Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,-2.5; 2,-7; 4,17; 6,
            5; 8,-20])              annotation (extent=[90,32; 110,52],
          rotation=180);
      Modelica.Mechanics.Rotational.Torque Torque1 
        annotation (extent=[62,38; 76,48],    rotation=180);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model(Pacejka_Friction_Data=Pacejka_120_70_ZR_17_Data) 
        annotation (extent=[-60,-50; -48,-40]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1(Pacejka_Friction_Data=Pacejka_180_55_ZR_17_Data) 
        annotation (extent=[26,-46; 38,-34]);
  equation 
      connect(ABS_F.to_Brake, Supermotard.Front_Brake1) annotation (points=[15.2,
            -91.2; 24,-91.2; 24,-44; 92,-44; 92,24; 8.9,24; 8.9,39.76],
          style(color=74, rgbcolor={0,0,127}));
      connect(ABS_F.Slip, Supermotard.Pin2) annotation (points=[0.8,-84.8; 0.8,
            -70; 14,-70; 14,-16.8; 38.48,-16.8],   style(color=3, rgbcolor={0,0,
              255}));
      connect(ABS2.to_Brake, Supermotard.Rear_Brake1) annotation (points=[-8.7,
            -58.3; 6,-58.3; 6,-10; -18,-10; -18,-1.12; -29.38,-1.12],
                                                                   style(color=
              74, rgbcolor={0,0,127}));
      connect(DD.y, ABS_F.u) annotation (points=[-7.2,-93; -6,-93; -6,-91.2; 
            0.8,-91.2], style(color=74, rgbcolor={0,0,127}));
      connect(DD1.y, ABS2.u) annotation (points=[-33.2,-59; -28.6,-59; -28.6,
            -58.3; -21.3,-58.3], style(color=74, rgbcolor={0,0,127}));
      connect(Supermotard.Pin1, ABS2.Slip) annotation (points=[-60.7,-26.32; 0,
            -26.32; 0,-50; -21.3,-50; -21.3,-52.7],
                                                 style(color=3, rgbcolor={0,0,
              255}));
      connect(Torque2.flange_b, Supermotard.Rear_Joint) annotation (points=[-58,-1;
            -54.365,-1; -54.365,-10.36; -59.25,-10.36],   style(color=0,
            rgbcolor={0,0,0}));
      connect(Aerodynamics1.frame_a, Supermotard.Pressure_center) annotation (
          points=[-11,81; -11,61.5; -9.08,61.5; -9.08,33.04],
                                                            style(
          color=0,
          rgbcolor={0,0,0},
          thickness=2));
      connect(const.y, DD1.u) annotation (points=[-71,-54; -62,-54; -62,-59;
            -51.6,-59], style(color=74, rgbcolor={0,0,127}));
      connect(const.y, DD.u) annotation (points=[-71,-54; -48,-54; -48,-93;
            -25.6,-93], style(color=74, rgbcolor={0,0,127}));
      connect(timeTable.y, Torque2.tau) annotation (points=[-111,-8; -94,-8;
            -94,-1; -73.4,-1], style(color=74, rgbcolor={0,0,127}));
      connect(joystick_Driver.frame_Seaddle, Supermotard.frame_Saddle1) 
        annotation (points=[-39,43; -39,31.5; -29.09,31.5; -29.09,17.64], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(joystick_Driver.Sensor1, Supermotard.Sensor) annotation (points=[-47,51; 
            -88,51; -88,-19.32; -73.75,-19.32],   style(color=74, rgbcolor={0,0,
              127}));
      connect(Supermotard.Steering, joystick_Driver.flange_steering) 
        annotation (points=[14.41,40.04; 14.41,55; -29,55], style(color=0,
            rgbcolor={0,0,0}));
      connect(timeTable1.y, Torque1.tau) annotation (points=[89,42; 84,42; 84,
            43; 77.4,43], style(color=74, rgbcolor={0,0,127}));
      connect(Torque1.flange_b, Supermotard.Steering) annotation (points=[62,43; 
            38,43; 38,40.04; 14.41,40.04], style(color=0, rgbcolor={0,0,0}));
      connect(pacejka_Friction_Model.Pin, Supermotard.Pin1) annotation (points=[-54,
            -40.5; -52,-40.5; -52,-26.32; -60.7,-26.32], style(color=3,
            rgbcolor={0,0,255}));
      connect(pacejka_Friction_Model1.Pin, Supermotard.Pin2) annotation (points=[32,-34.6; 
            32,-28.3; 38.48,-28.3; 38.48,-16.8],            style(color=3,
            rgbcolor={0,0,255}));
  end Supermotard_Test;
    
  model KTM_950_Roll_II 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    constant Real pi= Modelica.Constants.pi;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=25,
          NumberOfIntervals=100,
          Tolerance=1e-006),
      experimentSetupOutput(equdistant=false, events=false),
      DymolaStoredErrors);
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-100,-100; -80,-80]);
    inner Road road(
        d=0.01,
        a=55,
        b=50,
        choice=0) 
             annotation (extent=[46, -100; 100, -58]);
    public 
      inner parameter Supermotard_Dimension_MassPosition_Data 
        Dimension_MassPosition_data 
        annotation (extent=[60,80; 80,100]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model(                                                  Fz0=1144) 
        annotation (extent=[0,-56; 12,-46]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1(                                                  Fz0=1111) 
        annotation (extent=[62,-52; 74,-40]);
    protected 
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_120_70_ZR_17_Data 
        Pacejka_120_70_ZR_17_Data 
                                annotation (extent=[-80,80; -60,100]);
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_180_55_ZR_17_Data 
        Pacejka_180_55_ZR_17_Data 
                                annotation (extent=[-100,80; -80,100]);
    public 
    Motorcycle KTM_950(
        Rear_Wheel_data=Rear_Wheel_data,
        Dimension_MassPosition_data=Dimension_MassPosition_data,
        Rear_Pacejka_Friction_Data=Pacejka_180_55_ZR_17_Data,
        Front_Pacejka_Friction_Data=Pacejka_120_70_ZR_17_Data,
        Front_Suspension_data=Front_Suspension_data,
        Rear_Suspension_data=Rear_Suspension_data,
        xyz_init={0.40,0,0.3332 + 0.01},
        Front_Wheel_data=Front_Wheel_data) 
                          annotation (extent=[12,-30; 48,8]);
    public 
      Modelica.Blocks.Sources.Constant const(k=0) 
        annotation (extent=[8,-20; 16,-10]);
    protected 
      MotorcycleDynamics.Chassis.Data.KTM_950_Chassis_Data Chassis_Data 
        annotation (extent=[60,60; 80,80]);
      
      Suspension.Front_Suspension.Data.KTM_950_Front_Suspension_data 
        Front_Suspension_data annotation (extent=[40,80; 60,100]);
      Suspension.Rear_Suspension.Data.KTM_950_Rear_Suspension_Data 
        Rear_Suspension_data(                                  s_unstretched=0.25,
          Spring=[-0.0746,-22640; -0.070,-15950; -0.069,-15470; -0.0675,-14655;
            -0.065,-13740; -0.060,-12300; -0.050,-9900; -0.0465,-9025; -0.040,-8050;
            -0.030,-6550; -0.020,-5050; -0.010,-3550; 0,2050; 0.010,3550; 0.020,
            5050; 0.030,6550; 0.040,8050; 0.0465,9025; 0.050,9900; 0.060,12300;
            0.065,13740; 0.0675,14655; 0.069,15470; 0.070,15950; 0.0746,22640]) 
                             annotation (extent=[80,80; 100,100]);
      inner 
        MotorcycleDynamics.Rear_Swinging_Arm.Data.KTM_950_Rear_Swingin_Arm_Data
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Wheel.Data.KTM_950_Rear_Wheel_Data Rear_Wheel_data 
        annotation (extent=[40,60; 60,80]);
      MotorcycleDynamics.Wheel.Data.KTM_950_Front_Wheel_Data Front_Wheel_data 
        annotation (extent=[80,60; 100,80]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed(
        tableOnFile=true,
        tableName="vx_tab",
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
        annotation (extent=[-116,0; -96,20],   rotation=0);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Steer(
        tableOnFile=true,
        tableName="steer_tab",
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
                     annotation (extent=[80,20; 100,40], rotation=180);
      Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,0; 0.3,0.2; 6,
            13.3217*0 + 16; 10,13.2117*0 + 16; 10,10; 14,1; 15,0; 16,0]) 
                    annotation (extent=[-116,-30; -96,-10]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Roll(
        tableOnFile=true,
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        tableName="roll_tab",
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
                     annotation (extent=[-80,40; -60,60],rotation=0);
      
      Modelica.Blocks.Math.Add add annotation (extent=[-78,-16; -58,4]);
      Driver.Joystick_Driver_Real_GR joystick_Driver_Real_GR(
          Dimension_MassPosition_data=Dimension_MassPosition_data, k=0) 
        annotation (extent=[-2,16; 18,36]);
      Modelica.Mechanics.Rotational.Torque torque 
        annotation (extent=[42,28; 62,48], rotation=270);
      Driver.Speed_Control speed_Control(
        k=-35 - 20*0,
        Ti=0.07,
        k_fw=-20) 
        annotation (extent=[-48,-20; -28,0]);
      Modelica.Mechanics.Rotational.Torque torque1 
        annotation (extent=[-16,-34; 4,-14]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed1(
        tableOnFile=true,
        tableName="vx_tab",
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat",
        startTime=8.75) 
        annotation (extent=[-100,-60; -80,-40],rotation=0);
      Braking_System.ABS aBS(best_slip=0.06, Hz=200) 
        annotation (extent=[26,-62; 46,-42]);
      Modelica.Blocks.Interfaces.RealOutput Roll_SP[size(Roll.y, 1)] 
        annotation (extent=[-44,82; -24,102]);
      Modelica.Blocks.Interfaces.RealOutput Speed_SP 
        annotation (extent=[-108,22; -88,42]);
      Modelica.Blocks.Interfaces.RealOutput Moto_Sensor[6] 
        annotation (extent=[-50,-108; -30,-88]);
      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor 
        annotation (extent=[84,-8; 104,12]);
      Modelica.Blocks.Interfaces.RealOutput Steer_SP[size(Steer.y, 1)] 
        annotation (extent=[112,38; 132,58]);
      Modelica.Blocks.Interfaces.RealOutput Steer_Sensor 
        annotation (extent=[118,-8; 138,12]);
      Modelica.Mechanics.MultiBody.Sensors.RelativeSensor relativeSensor(
          get_a_rel=true, get_z_rel=true) 
        annotation (extent=[86,-34; 106,-14], rotation=90);
      Modelica.Blocks.Interfaces.RealOutput Acceleration[size(relativeSensor.y,
        1)] annotation (extent=[120,-34; 140,-14]);
  equation 
  // torque_Control.Rear_Slip=KTM_950.Pin1.slip;
  torque.tau= if time<12.97 then 0 else Roll.y[1]*(35*0+45*0+55)+(Roll.y[1]-KTM_950.Sensor[6])*(55*0+50);
      
      connect(KTM_950.Pin2, pacejka_Friction_Model1.Pin)  annotation (points=[68.16,
            -31.9; 68.16,-35.95; 68,-35.95; 68,-40.6],     style(color=3,
          rgbcolor={0,0,255}));
      connect(KTM_950.Pin1, pacejka_Friction_Model.Pin)  annotation (points=[6.6,
            -38.36; 6.6,-42.18; 6,-42.18; 6,-46.5],           style(color=3,
          rgbcolor={0,0,255}));
      connect(Aerodynamics1.frame_a, KTM_950.Pressure_center)  annotation (points=[-11,81;
            -11,49.5; 38.64,49.5; 38.64,1.92],          style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
      connect(const.y, KTM_950.Rear_Brake1)  annotation (points=[16.4,-15; 22,
            -15; 22,-21.26; 26.04,-21.26],
                                    style(color=74, rgbcolor={0,0,127}));
      connect(timeTable1.y, add.u2) annotation (points=[-95,-20; -90,-20; -90,
            -12; -80,-12], style(color=74, rgbcolor={0,0,127}));
      connect(add.u1, Speed.y[1]) annotation (points=[-80,0; -90,0; -90,10; -95,
            10], style(color=74, rgbcolor={0,0,127}));
      connect(joystick_Driver_Real_GR.frame_Seaddle, KTM_950.frame_Saddle1) 
        annotation (points=[7,17; 7,4.5; 26.22,4.5; 26.22,-8.53], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(joystick_Driver_Real_GR.flange_steering, KTM_950.Steering) 
        annotation (points=[17,29; 53.22,29; 53.22,6.67], style(color=0,
            rgbcolor={0,0,0}));
      connect(joystick_Driver_Real_GR.Sensor1, KTM_950.Sensor) annotation (
          points=[-1,25; -10,25; -10,-33.61; -1.5,-33.61], style(color=74,
            rgbcolor={0,0,127}));
      connect(torque.flange_b, KTM_950.Steering) annotation (points=[52,28; 52,
            6.67; 53.22,6.67], style(color=0, rgbcolor={0,0,0}));
      connect(speed_Control.friction_Connector, KTM_950.Pin1) annotation (
          points=[-48,-17; -48,-38.36; 6.6,-38.36], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(KTM_950.Sensor, speed_Control.Sensor) annotation (points=[-1.5,
            -33.61; -54,-33.61; -54,-5; -49,-5], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(add.y, speed_Control.Speed_SP) annotation (points=[-57,-6; -56,-6;
            -56,-1; -49,-1], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(torque1.flange_b, KTM_950.Rear_Joint) annotation (points=[4,-24;
            4,-27.53; 7.5,-27.53], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(speed_Control.Rear_Torque, torque1.tau) annotation (points=[-27,
            -1; -18,-1; -18,-24], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(Speed1.y[1], speed_Control.FW) annotation (points=[-79,-50; -52,
            -50; -52,-11; -48,-11], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(KTM_950.Front_Brake1, aBS.to_Brake) annotation (points=[49.8,6.48;
            46,6.48; 46,-26; 52,-26; 52,-51; 45,-51], style(color=74, rgbcolor=
              {0,0,127}));
      connect(KTM_950.Pin2, aBS.Slip) annotation (points=[68.16,-31.9; 68.16,
            -36; 27,-36; 27,-43], style(color=3, rgbcolor={0,0,255}));
      connect(speed_Control.Brake, aBS.u) annotation (points=[-27,-17.2; -24,
            -17.2; -24,-58; 18,-58; 18,-51; 27,-51], style(color=74, rgbcolor={
              0,0,127}));
      connect(Roll.y, Roll_SP) annotation (points=[-59,50; -46,50; -46,92; -34,
            92], style(color=74, rgbcolor={0,0,127}));
      connect(add.y, Speed_SP) annotation (points=[-57,-6; -54,-6; -54,32; -98,
            32], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Sensor, Moto_Sensor) annotation (points=[-1.5,-33.61; -40,
            -33.61; -40,-98], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Steering, angleSensor.flange_a) annotation (points=[53.22,
            6.67; 67.61,6.67; 67.61,2; 84,2], style(color=0, rgbcolor={0,0,0}));
      connect(Steer.y, Steer_SP) annotation (points=[79,30; 72,30; 72,48; 122,
            48], style(color=74, rgbcolor={0,0,127}));
      connect(angleSensor.phi, Steer_Sensor) annotation (points=[105,2; 128,2],
          style(color=74, rgbcolor={0,0,127}));
      connect(relativeSensor.frame_b, KTM_950.frame_Saddle1) annotation (points=
           [96,-14; 62,-14; 62,-8.53; 26.22,-8.53], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(relativeSensor.frame_a, KTM_950.frame_rear_hub1) annotation (
          points=[96,-34; 54,-34; 54,-24.3; 9.12,-24.3], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(relativeSensor.y, Acceleration) annotation (points=[107,-24; 130,
            -24], style(color=74, rgbcolor={0,0,127}));
  end KTM_950_Roll_II;
    
  model KTM_950_Roll_SP 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    constant Real pi= Modelica.Constants.pi;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=100,
          NumberOfIntervals=100,
          Tolerance=1e-006),
      experimentSetupOutput(
          states=false,
          derivatives=false,
          inputs=false,
          auxiliaries=false,
          equdistant=false,
          events=false),
      DymolaStoredErrors,
        Commands(file="Temp.mos" "Temp", file="Temp.mos" "Temp"));
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-100,-100; -80,-80]);
    inner Road road(
        d=0.01,
        a=55,
        b=50,
        choice=0) 
             annotation (extent=[46, -100; 100, -58]);
    public 
      inner parameter Supermotard_Dimension_MassPosition_Data 
        Dimension_MassPosition_data 
        annotation (extent=[60,80; 80,100]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model(                                                  Fz0=1144) 
        annotation (extent=[0,-56; 12,-46]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1(                                                  Fz0=1111) 
        annotation (extent=[62,-52; 74,-40]);
    protected 
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_120_70_ZR_17_Data 
        Pacejka_120_70_ZR_17_Data 
                                annotation (extent=[-80,80; -60,100]);
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_180_55_ZR_17_Data 
        Pacejka_180_55_ZR_17_Data 
                                annotation (extent=[-100,80; -80,100]);
    public 
    Motorcycle KTM_950(
        Rear_Wheel_data=Rear_Wheel_data,
        Dimension_MassPosition_data=Dimension_MassPosition_data,
        Rear_Pacejka_Friction_Data=Pacejka_180_55_ZR_17_Data,
        Front_Pacejka_Friction_Data=Pacejka_120_70_ZR_17_Data,
        Front_Suspension_data=Front_Suspension_data,
        Rear_Suspension_data=Rear_Suspension_data,
        xyz_init={0.40,0,0.3332 + 0.01},
        Front_Wheel_data=Front_Wheel_data) 
                          annotation (extent=[12,-30; 48,8]);
    public 
      Modelica.Blocks.Sources.Constant const(k=0) 
        annotation (extent=[8,-20; 16,-10]);
    protected 
      MotorcycleDynamics.Chassis.Data.KTM_950_Chassis_Data Chassis_Data 
        annotation (extent=[60,60; 80,80]);
      
      Suspension.Front_Suspension.Data.KTM_950_Front_Suspension_data 
        Front_Suspension_data annotation (extent=[40,80; 60,100]);
      Suspension.Rear_Suspension.Data.KTM_950_Rear_Suspension_Data 
        Rear_Suspension_data(                                  s_unstretched=0.25,
          Spring=[-0.0746,-22640; -0.070,-15950; -0.069,-15470; -0.0675,-14655;
            -0.065,-13740; -0.060,-12300; -0.050,-9900; -0.0465,-9025; -0.040,-8050;
            -0.030,-6550; -0.020,-5050; -0.010,-3550; 0,2050; 0.010,3550; 0.020,
            5050; 0.030,6550; 0.040,8050; 0.0465,9025; 0.050,9900; 0.060,12300;
            0.065,13740; 0.0675,14655; 0.069,15470; 0.070,15950; 0.0746,22640]) 
                             annotation (extent=[80,80; 100,100]);
      inner 
        MotorcycleDynamics.Rear_Swinging_Arm.Data.KTM_950_Rear_Swingin_Arm_Data
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Wheel.Data.KTM_950_Rear_Wheel_Data Rear_Wheel_data 
        annotation (extent=[40,60; 60,80]);
      MotorcycleDynamics.Wheel.Data.KTM_950_Front_Wheel_Data Front_Wheel_data 
        annotation (extent=[80,60; 100,80]);
      
    public 
      Driver.Joystick_Driver_Real_GR joystick_Driver_Real_GR(
          Dimension_MassPosition_data=Dimension_MassPosition_data) 
        annotation (extent=[-2,16; 18,36]);
      Modelica.Mechanics.Rotational.Torque torque 
        annotation (extent=[42,28; 62,48], rotation=270);
      Modelica.Mechanics.Rotational.Torque torque1 
        annotation (extent=[-16,-34; 4,-14]);
      Modelica.Blocks.Sources.Ramp ramp(height=-5, startTime=20) 
        annotation (extent=[-52,46; -32,66]);
      Modelica.Blocks.Interfaces.RealOutput Sensor[4] 
        annotation (extent=[100,-2; 120,18]);
      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor 
        annotation (extent=[68,2; 88,22]);
      Modelica.Blocks.Sources.TimeTable timeTable2(
                                                  table=[0,0; 0.3,0; 0.8,-160;
            3,-140; 10,-85; 20,-85]) 
                                    annotation (extent=[-56,-36; -36,-16]);
    public 
      Modelica.Blocks.Sources.Constant const1(k=0) 
        annotation (extent=[38,2; 46,12]);
  equation 
  // torque_Control.Rear_Slip=KTM_950.Pin1.slip;
  //torque.tau= if time<12.97 then 0 else Roll.y[1]*(35*0+45*0+55)+(Roll.y[1]-KTM_950.Sensor[6])*(55*0+50);
      
      connect(KTM_950.Pin2, pacejka_Friction_Model1.Pin)  annotation (points=[68.16,
            -31.9; 68.16,-35.95; 68,-35.95; 68,-40.6],     style(color=3,
          rgbcolor={0,0,255}));
      connect(KTM_950.Pin1, pacejka_Friction_Model.Pin)  annotation (points=[6.6,
            -38.36; 6.6,-42.18; 6,-42.18; 6,-46.5],           style(color=3,
          rgbcolor={0,0,255}));
      connect(Aerodynamics1.frame_a, KTM_950.Pressure_center)  annotation (points=[-11,81;
            -11,49.5; 38.64,49.5; 38.64,1.92],          style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
      connect(const.y, KTM_950.Rear_Brake1)  annotation (points=[16.4,-15; 22,
            -15; 22,-21.26; 26.04,-21.26],
                                    style(color=74, rgbcolor={0,0,127}));
      connect(joystick_Driver_Real_GR.frame_Seaddle, KTM_950.frame_Saddle1) 
        annotation (points=[7,17; 7,4.5; 26.22,4.5; 26.22,-8.53], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(joystick_Driver_Real_GR.flange_steering, KTM_950.Steering) 
        annotation (points=[17,29; 53.22,29; 53.22,6.67], style(color=0,
            rgbcolor={0,0,0}));
      connect(joystick_Driver_Real_GR.Sensor1, KTM_950.Sensor) annotation (
          points=[-1,25; -10,25; -10,-33.61; -1.5,-33.61], style(color=74,
            rgbcolor={0,0,127}));
      connect(torque.flange_b, KTM_950.Steering) annotation (points=[52,28; 52,
            6.67; 53.22,6.67], style(color=0, rgbcolor={0,0,0}));
      connect(torque1.flange_b, KTM_950.Rear_Joint) annotation (points=[4,-24;
            4,-27.53; 7.5,-27.53], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(ramp.y, torque.tau) annotation (points=[-31,56; 52,56; 52,50],
          style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Steering, angleSensor.flange_a) annotation (points=[53.22,
            6.67; 60.61,6.67; 60.61,12; 68,12], style(color=0, rgbcolor={0,0,0}));
      connect(angleSensor.phi, Sensor[1]) annotation (points=[89,12; 96,12; 96,
            0.5; 110,0.5], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Sensor[4], Sensor[2]) annotation (points=[-1.17,-33.61;
            -1.17,5.5; 110,5.5], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Sensor[6], Sensor[3]) annotation (points=[0.15,-33.61; 
            52.25,-33.61; 52.25,10.5; 110,10.5], style(color=74, rgbcolor={0,0,
              127}));
      connect(joystick_Driver_Real_GR.phi1, Sensor[4]) annotation (points=[18.2,
            26.4; 60.1,26.4; 60.1,15.5; 110,15.5], style(color=74, rgbcolor={0,
              0,127}));
      connect(const1.y, KTM_950.Front_Brake1) annotation (points=[46.4,7; 48.2,
            7; 48.2,6.48; 49.8,6.48], style(color=74, rgbcolor={0,0,127}));
      connect(timeTable2.y, torque1.tau) annotation (points=[-35,-26; -28,-26;
            -28,-24; -18,-24], style(color=74, rgbcolor={0,0,127}));
  end KTM_950_Roll_SP;
  end Example;
  
  package Validation 
  model KTM_950_Roll_Speed_SP 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    constant Real pi= Modelica.Constants.pi;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=25,
          NumberOfIntervals=100,
          Tolerance=1e-006),
      experimentSetupOutput(equdistant=false, events=false),
      DymolaStoredErrors);
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-100,-100; -80,-80]);
    inner Road road(
        d=0.01,
        a=55,
        b=50,
        choice=0) 
             annotation (extent=[46, -100; 100, -58]);
    public 
      inner parameter Supermotard_Dimension_MassPosition_Data 
        Dimension_MassPosition_data 
        annotation (extent=[60,80; 80,100]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model(                                                  Fz0=1144) 
        annotation (extent=[0,-56; 12,-46]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1(                                                  Fz0=1111) 
        annotation (extent=[62,-52; 74,-40]);
    protected 
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_120_70_ZR_17_Data 
        Pacejka_120_70_ZR_17_Data 
                                annotation (extent=[-80,80; -60,100]);
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_180_55_ZR_17_Data 
        Pacejka_180_55_ZR_17_Data 
                                annotation (extent=[-100,80; -80,100]);
    public 
    Motorcycle KTM_950(
        Rear_Wheel_data=Rear_Wheel_data,
        Dimension_MassPosition_data=Dimension_MassPosition_data,
        Rear_Pacejka_Friction_Data=Pacejka_180_55_ZR_17_Data,
        Front_Pacejka_Friction_Data=Pacejka_120_70_ZR_17_Data,
        Front_Suspension_data=Front_Suspension_data,
        Rear_Suspension_data=Rear_Suspension_data,
        xyz_init={0.40,0,0.3332 + 0.01},
        Front_Wheel_data=Front_Wheel_data) 
                          annotation (extent=[12,-30; 48,8]);
    public 
      Modelica.Blocks.Sources.Constant const(k=0) 
        annotation (extent=[8,-20; 16,-10]);
    protected 
      MotorcycleDynamics.Chassis.Data.KTM_950_Chassis_Data Chassis_Data 
        annotation (extent=[60,60; 80,80]);
      
      Suspension.Front_Suspension.Data.KTM_950_Front_Suspension_data 
        Front_Suspension_data annotation (extent=[40,80; 60,100]);
      Suspension.Rear_Suspension.Data.KTM_950_Rear_Suspension_Data 
        Rear_Suspension_data(                                  s_unstretched=0.25,
          Spring=[-0.0746,-22640; -0.070,-15950; -0.069,-15470; -0.0675,-14655;
            -0.065,-13740; -0.060,-12300; -0.050,-9900; -0.0465,-9025; -0.040,-8050;
            -0.030,-6550; -0.020,-5050; -0.010,-3550; 0,2050; 0.010,3550; 0.020,
            5050; 0.030,6550; 0.040,8050; 0.0465,9025; 0.050,9900; 0.060,12300;
            0.065,13740; 0.0675,14655; 0.069,15470; 0.070,15950; 0.0746,22640]) 
                             annotation (extent=[80,80; 100,100]);
      inner 
        MotorcycleDynamics.Rear_Swinging_Arm.Data.KTM_950_Rear_Swingin_Arm_Data
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Wheel.Data.KTM_950_Rear_Wheel_Data Rear_Wheel_data 
        annotation (extent=[40,60; 60,80]);
      MotorcycleDynamics.Wheel.Data.KTM_950_Front_Wheel_Data Front_Wheel_data 
        annotation (extent=[80,60; 100,80]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed(
        tableOnFile=true,
        tableName="vx_tab",
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
        annotation (extent=[-116,0; -96,20],   rotation=0);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Steer(
        tableOnFile=true,
        tableName="steer_tab",
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
                     annotation (extent=[80,20; 100,40], rotation=180);
      Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,0; 0.3,0.2; 6,
            13.3217*0 + 16; 10,13.2117*0 + 16; 10,10; 14,1; 15,0; 16,0]) 
                    annotation (extent=[-116,-30; -96,-10]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Roll(
        tableOnFile=true,
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        tableName="roll_tab",
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
                     annotation (extent=[-80,40; -60,60],rotation=0);
      
      Modelica.Blocks.Math.Add add annotation (extent=[-78,-16; -58,4]);
      Driver.Joystick_Driver_Real_GR joystick_Driver_Real_GR(
          Dimension_MassPosition_data=Dimension_MassPosition_data, k=0) 
        annotation (extent=[-2,16; 18,36]);
      Modelica.Mechanics.Rotational.Torque torque 
        annotation (extent=[42,28; 62,48], rotation=270);
      Driver.Speed_Control speed_Control(
        k=-35 - 20*0,
        Ti=0.07,
        k_fw=-20) 
        annotation (extent=[-48,-20; -28,0]);
      Modelica.Mechanics.Rotational.Torque torque1 
        annotation (extent=[-16,-34; 4,-14]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed1(
        tableOnFile=true,
        tableName="vx_tab",
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat",
        startTime=8.75) 
        annotation (extent=[-100,-60; -80,-40],rotation=0);
      Braking_System.ABS aBS(best_slip=0.06, Hz=200) 
        annotation (extent=[26,-62; 46,-42]);
      Modelica.Blocks.Interfaces.RealOutput Roll_SP[size(Roll.y, 1)] 
        annotation (extent=[-44,82; -24,102]);
      Modelica.Blocks.Interfaces.RealOutput Speed_SP 
        annotation (extent=[-108,22; -88,42]);
      Modelica.Blocks.Interfaces.RealOutput Moto_Sensor[6] 
        annotation (extent=[-50,-108; -30,-88]);
      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor 
        annotation (extent=[84,-8; 104,12]);
      Modelica.Blocks.Interfaces.RealOutput Steer_SP[size(Steer.y, 1)] 
        annotation (extent=[112,38; 132,58]);
      Modelica.Blocks.Interfaces.RealOutput Steer_Sensor 
        annotation (extent=[118,-8; 138,12]);
      Modelica.Mechanics.MultiBody.Sensors.RelativeSensor relativeSensor(
          get_a_rel=true, get_z_rel=true) 
        annotation (extent=[86,-34; 106,-14], rotation=90);
      Modelica.Blocks.Interfaces.RealOutput Acceleration[size(relativeSensor.y,
        1)] annotation (extent=[120,-34; 140,-14]);
  equation 
  // torque_Control.Rear_Slip=KTM_950.Pin1.slip;
  torque.tau= if time<12.97 then 0 else Roll.y[1]*(35*0+45*0+55)+(Roll.y[1]-KTM_950.Sensor[6])*(55*0+50);
      
      connect(KTM_950.Pin2, pacejka_Friction_Model1.Pin)  annotation (points=[68.16,
            -31.9; 68.16,-35.95; 68,-35.95; 68,-40.6],     style(color=3,
          rgbcolor={0,0,255}));
      connect(KTM_950.Pin1, pacejka_Friction_Model.Pin)  annotation (points=[6.6,
            -38.36; 6.6,-42.18; 6,-42.18; 6,-46.5],           style(color=3,
          rgbcolor={0,0,255}));
      connect(Aerodynamics1.frame_a, KTM_950.Pressure_center)  annotation (points=[-11,81;
            -11,49.5; 38.64,49.5; 38.64,1.92],          style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
      connect(const.y, KTM_950.Rear_Brake1)  annotation (points=[16.4,-15; 22,
            -15; 22,-21.26; 26.04,-21.26],
                                    style(color=74, rgbcolor={0,0,127}));
      connect(timeTable1.y, add.u2) annotation (points=[-95,-20; -90,-20; -90,
            -12; -80,-12], style(color=74, rgbcolor={0,0,127}));
      connect(add.u1, Speed.y[1]) annotation (points=[-80,0; -90,0; -90,10; -95,
            10], style(color=74, rgbcolor={0,0,127}));
      connect(joystick_Driver_Real_GR.frame_Seaddle, KTM_950.frame_Saddle1) 
        annotation (points=[7,17; 7,4.5; 26.22,4.5; 26.22,-8.53], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(joystick_Driver_Real_GR.flange_steering, KTM_950.Steering) 
        annotation (points=[17,29; 53.22,29; 53.22,6.67], style(color=0,
            rgbcolor={0,0,0}));
      connect(joystick_Driver_Real_GR.Sensor1, KTM_950.Sensor) annotation (
          points=[-1,25; -10,25; -10,-33.61; -1.5,-33.61], style(color=74,
            rgbcolor={0,0,127}));
      connect(torque.flange_b, KTM_950.Steering) annotation (points=[52,28; 52,
            6.67; 53.22,6.67], style(color=0, rgbcolor={0,0,0}));
      connect(speed_Control.friction_Connector, KTM_950.Pin1) annotation (
          points=[-48,-17; -48,-38.36; 6.6,-38.36], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(KTM_950.Sensor, speed_Control.Sensor) annotation (points=[-1.5,
            -33.61; -54,-33.61; -54,-5; -49,-5], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(add.y, speed_Control.Speed_SP) annotation (points=[-57,-6; -56,-6;
            -56,-1; -49,-1], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(torque1.flange_b, KTM_950.Rear_Joint) annotation (points=[4,-24;
            4,-27.53; 7.5,-27.53], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(speed_Control.Rear_Torque, torque1.tau) annotation (points=[-27,
            -1; -18,-1; -18,-24], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(Speed1.y[1], speed_Control.FW) annotation (points=[-79,-50; -52,
            -50; -52,-11; -48,-11], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(KTM_950.Front_Brake1, aBS.to_Brake) annotation (points=[49.8,6.48;
            46,6.48; 46,-26; 52,-26; 52,-51; 45,-51], style(color=74, rgbcolor=
              {0,0,127}));
      connect(KTM_950.Pin2, aBS.Slip) annotation (points=[68.16,-31.9; 68.16,
            -36; 27,-36; 27,-43], style(color=3, rgbcolor={0,0,255}));
      connect(speed_Control.Brake, aBS.u) annotation (points=[-27,-17.2; -24,
            -17.2; -24,-58; 18,-58; 18,-51; 27,-51], style(color=74, rgbcolor={
              0,0,127}));
      connect(Roll.y, Roll_SP) annotation (points=[-59,50; -46,50; -46,92; -34,
            92], style(color=74, rgbcolor={0,0,127}));
      connect(add.y, Speed_SP) annotation (points=[-57,-6; -54,-6; -54,32; -98,
            32], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Sensor, Moto_Sensor) annotation (points=[-1.5,-33.61; -40,
            -33.61; -40,-98], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Steering, angleSensor.flange_a) annotation (points=[53.22,
            6.67; 67.61,6.67; 67.61,2; 84,2], style(color=0, rgbcolor={0,0,0}));
      connect(Steer.y, Steer_SP) annotation (points=[79,30; 72,30; 72,48; 122,
            48], style(color=74, rgbcolor={0,0,127}));
      connect(angleSensor.phi, Steer_Sensor) annotation (points=[105,2; 128,2],
          style(color=74, rgbcolor={0,0,127}));
      connect(relativeSensor.frame_b, KTM_950.frame_Saddle1) annotation (points=[96,-13;
            62,-13; 62,-8.53; 26.22,-8.53],         style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(relativeSensor.frame_a, KTM_950.frame_rear_hub1) annotation (
          points=[96,-35; 54,-35; 54,-24.3; 9.12,-24.3], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(relativeSensor.y, Acceleration) annotation (points=[107,-24; 130,
            -24], style(color=74, rgbcolor={0,0,127}));
  end KTM_950_Roll_Speed_SP;
  end Validation;
  
  package temp 
    
  model SimplePilot 
    parameter Real[3] a1pos;
    parameter Real[3] a2pos;
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape1(
      m=10,
      r={0,0,0.35},
      r_CM={0,0,0.175},
      I_33=10*1/12*0.35^2,
      initType=Modelica.Mechanics.MultiBody.Types.Init.Position,
      r_0_start=a1pos) annotation (extent=[-54, -40; -34, -20], rotation=90);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape2(
      m=10,
      I_33=10*1/12*0.35^2,
      r={0,0,0.35},
      r_CM={0,0,0.175},
      initType=Modelica.Mechanics.MultiBody.Types.Init.Position,
      r_0_start=a2pos) annotation (extent=[16, -42; 36, -22], rotation=90);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape3(
      m=10,
      r={0,0.18,0},
      I_22=10*1/12*0.18^2,
      r_CM={0,0.09,0}) annotation (extent=[-40, -12; -20, 8], rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape4(
      m=10,
      r={0,-0.18,0},
      r_CM={0,-0.09,0},
      I_22=10*1/12*0.18^2) annotation (extent=[0, -12; 20, 8], rotation=180);
    annotation (Diagram);
    Modelica.Mechanics.MultiBody.Parts.Body Body1(
                               m=10, initType=Modelica.Mechanics.MultiBody.
          Types.Init.Free) 
      annotation (extent=[-20, 73; 0, 93], rotation=90);
    Modelica.Mechanics.MultiBody.Joints.ActuatedRevolute ActuatedRevolute1(
                                                        n={1,0,0}) 
      annotation (extent=[-20, 12; 0, 32], rotation=90);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape5(
      r={0,0,0.5},
      r_CM={0,0,0.25},
      m=40,
      I_33=40*1/12*0.5^2) annotation (extent=[-20, 42; 0, 62], rotation=90);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a1 
      annotation (extent=[-50, -86; -30, -66]);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_a frame_a2 
                                          annotation (extent=[-2, -86; 18, -66]);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape6(
      m=10,
      r={0,-0.18,0},
      r_CM={0,-0.09,0},
      I_22=10*1/12*0.18^2) annotation (extent=[-2, 52; 18, 72], rotation=180);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape7(
      m=10,
      r={0,0.18,0},
      I_22=10*1/12*0.18^2,
      r_CM={0,0.09,0}) annotation (extent=[-42, 52; -22, 72], rotation=0);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape8(
      m=2,
      I_33=2*1/12*0.3^2,
      r_CM={0,0,-0.15},
      r={0,0,-0.3}) annotation (extent=[-52, 22; -32, 42], rotation=270);
    Modelica.Mechanics.MultiBody.Parts.BodyShape BodyShape9(
      m=2,
      I_33=2*1/12*0.3^2,
      r={0,0,-0.3},
      r_CM={0,0,-0.15}) annotation (extent=[14, 22; 34, 42], rotation=270);
    Modelica.Mechanics.Rotational.Interfaces.Flange_a axis1 
      annotation (extent=[-100, 0; -80, 20]);
    Modelica.Mechanics.MultiBody.Forces.SpringDamperParallel 
        SpringDamperParallel1(                                  c=1e6, d=1e3) 
      annotation (extent=[-68, -70; -48, -50], rotation=90);
    Modelica.Mechanics.MultiBody.Forces.SpringDamperParallel 
        SpringDamperParallel2(                                  c=1e6, d=1e3) 
      annotation (extent=[26, -74; 46, -54], rotation=90);
  equation 
    connect(BodyShape3.frame_a, BodyShape1.frame_b) annotation (points=[-40,-2;
            -44,-2; -44,-20], style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape2.frame_b, BodyShape4.frame_a) annotation (points=[26,-22;
            26,-2; 20,-2], style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape3.frame_b, BodyShape4.frame_b) annotation (points=[-20,-2;
            -10,-2; -10,-2; 0,-2],   style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape3.frame_b, ActuatedRevolute1.frame_a) annotation (points=[-20,-2;
            -10,-2; -10,12],          style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(ActuatedRevolute1.frame_b, BodyShape5.frame_a) annotation (points=[-10,32;
            -10,42],         style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape5.frame_b, Body1.frame_a) annotation (points=[-10,62; -10,
            73],
               style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape7.frame_b, BodyShape5.frame_b) annotation (points=[-22,62;
            -13.5,62; -13.5,62; -10,62],  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape5.frame_b, BodyShape6.frame_b) annotation (points=[-10,62;
            -4,62; -4,62; -2,62],  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape8.frame_a, BodyShape7.frame_a) annotation (points=[-42,42;
            -42,62; -42,62], style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(BodyShape6.frame_a, BodyShape9.frame_a) annotation (points=[18,62; 24,
            62; 24,42],    style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(ActuatedRevolute1.axis, axis1) annotation (points=[-20, 22; -58, 22;
          -58, 10; -90, 10], style(color=0, rgbcolor={0,0,0}));
    connect(SpringDamperParallel1.frame_a, frame_a1) annotation (points=[-58,-70;
            -58,-76; -40,-76], style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(SpringDamperParallel1.frame_b, BodyShape1.frame_a) annotation (
        points=[-58,-50; -50,-50; -50,-50; -44,-50; -44,-40],      style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(frame_a2, SpringDamperParallel2.frame_a) annotation (points=[8,-76;
            36,-74],
                   style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
    connect(SpringDamperParallel2.frame_b, BodyShape2.frame_a) annotation (
        points=[36,-54; 30,-54; 30,-42; 26,-42],     style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
  initial equation 
    a1pos = frame_a1.r_0;
    a2pos = frame_a2.r_0;
  end SimplePilot;
    
  model Stability_Control 
    Modelica.Blocks.Continuous.PI PI1(T=T, k=k) 
      annotation (extent=[-8, 0; 12, 20]);
    annotation (Diagram);
    Modelica.Mechanics.MultiBody.Interfaces.Frame_b frame_Seaddle 
      annotation (extent=[60, -100; 80, -80], rotation=90);
    Modelica.Mechanics.MultiBody.Parts.Body Disk(
                              m=20, I_11=10) 
      annotation (extent=[60, 30; 80, 50], rotation=90);
    Modelica.Mechanics.MultiBody.Joints.ActuatedRevolute ActuatedRevolute1(
                                                        n={1,0,0}) 
      annotation (extent=[60, 0; 80, 20], rotation=90);
    Modelica.Mechanics.Rotational.Torque Torque1 
      annotation (extent=[30, 0; 50, 20]);
    Modelica.Blocks.Routing.ExtractSignal ExtractSignal1(             nin=3) 
      annotation (extent=[-44, 0; -24, 20]);
    Modelica.Mechanics.MultiBody.Sensors.AbsoluteSensor AbsoluteSensor2(
      get_r_abs=false,
      get_w_abs=true,
      animation=false) annotation (extent=[-80, 0; -60, 20]);
    parameter Real k[:]={-100} "PI Gain";
    parameter Modelica.SIunits.Time T[:]={0.1} "PI Time Constant";
  equation 
    connect(ActuatedRevolute1.frame_b, Disk.frame_a) annotation (points=[70,20;
            70,30],
                  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2,
        gradient=1,
        fillColor=42,
        rgbfillColor={127,0,0}));
    connect(ActuatedRevolute1.frame_a, frame_Seaddle) annotation (points=[70,0; 70,
            -90],   style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2,
        gradient=1,
        fillColor=42,
        rgbfillColor={127,0,0}));
    connect(Torque1.flange_b, ActuatedRevolute1.axis) annotation (points=[50,
          10; 60, 10], style(
        color=0,
        rgbcolor={0,0,0},
        gradient=1,
        fillColor=42,
        rgbfillColor={127,0,0}));
    connect(PI1.y,Torque1.tau)           annotation (points=[13, 10; 28, 10],
        style(
        color=3,
        rgbcolor={0,0,255},
        gradient=1,
        fillColor=42,
        rgbfillColor={127,0,0}));
    connect(ExtractSignal1.y[1],PI1.u)          annotation (points=[-23, 10; -10,
          10], style(color=3, rgbcolor={0,0,255}));
    connect(AbsoluteSensor2.y,ExtractSignal1.u)             annotation (points=
          [-59, 10; -46, 10], style(color=3, rgbcolor={0,0,255}));
    connect(frame_Seaddle, AbsoluteSensor2.frame_a) annotation (points=[70,-90;
            -96,-90; -96,10; -80,10],  style(
        color=0,
        rgbcolor={0,0,0},
        thickness=2));
  end Stability_Control;
    
  model Steer_Control_PI_style 
      import Modelica.Constants.*;
      import Modelica.Mechanics.MultiBody.Frames.*;
      import Modelica.Math.*;
    Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
      annotation (extent=[96, -76; 110, -64]);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
      annotation (extent=[80, -100; 100, -80]);
    Modelica.Blocks.Math.Atan Atan1 annotation (extent=[32, 72; 44, 84]);
    Modelica.Blocks.Math.Product Product1 annotation (extent=[-30, 64; -18, 76]);
    Modelica.Blocks.Routing.ExtractSignal Vx(             nin=7, extract={4}) 
      annotation (extent=[-56, 64; -38, 74]);
    Modelica.Blocks.Routing.ExtractSignal roll_angle(
      nout=1,
      nin=7,
      extract={7}) annotation (extent=[-56, 48; -38, 58]);
    Modelica.Blocks.Math.Product Product2 annotation (extent=[-12, 68; 0, 80]);
    Modelica.Blocks.Math.Add Add1[+1](
      each k1=
         +1,
      each k2=
         -1) annotation (extent=[50, 68; 58, 80]);
    Modelica.Blocks.Math.Gain Gain2(k=1/9.8066) 
      annotation (extent=[8, 68; 20, 80]);
    Modelica.Blocks.Interfaces.RealInput Ct 
      annotation (extent=[-100, 80; -80, 100]);
    annotation (Diagram);
    Modelica.Blocks.Math.Gain tmp(k=+1)   annotation (extent=[24, -74; 36, -62]);
    Modelica.Blocks.Math.Add Add3(k1=+1, k2=-1) 
      annotation (extent=[-32, 4; -24, 14]);
    Modelica.Blocks.Interfaces.RealInput Sensor[2] 
      annotation (extent=[-100, 20; -80, 40]);
    parameter Real k1=0.41;
    parameter Real k2=1.5;
    parameter Real k3=2.5;
    parameter Real k4=3;
    parameter Modelica.SIunits.Time T1=1.8;
    parameter Modelica.SIunits.Time T2=1;
    parameter Modelica.SIunits.Time T3=0.5;
    parameter Modelica.SIunits.Time T4=0.1;
    Modelica.Blocks.Continuous.PI PI1(T=T1, k=k) 
      annotation (extent=[-48, 16; -38, 26]);
    Modelica.Blocks.Continuous.PI PI4(T=T4, k=k4) 
      annotation (extent=[0, -74; 12, -62]);
    Modelica.Blocks.Math.Add Add2(k1=+1, k2=-1) 
      annotation (extent=[4, -24; 12, -12]);
    Modelica.Blocks.Continuous.PI PI2(T=T2, k=k2) 
      annotation (extent=[-12, -12; -2, -2]);
    Modelica.Blocks.Continuous.PI PI3(T=T2, k=k2) 
      annotation (extent=[24, -30; 34, -20]);
    Modelica.Blocks.Math.Add Add4(k1=+1, k2=-1) 
      annotation (extent=[40, -42; 48, -30]);
    Modelica.Blocks.Continuous.Derivative Derivative3 
      annotation (extent=[-64, 0; -52, 12]);
    Modelica.Blocks.Continuous.Derivative Derivative1 
      annotation (extent=[-48, -26; -36, -14]);
    Modelica.Blocks.Continuous.Derivative Derivative2 
      annotation (extent=[-24, -46; -12, -34]);
    Modelica.Blocks.Math.Add Add5[+1](
      each k1=
         +1,
      each k2=
         -1) annotation (extent=[56, -78; 64, -66]);
    Non_Linear_Damper Non_Linear_Damper1(k2=-20) 
      annotation (extent=[30, -104; 50, -84]);
  initial algorithm 
    Torque1.tau := 0;
  equation 
    connect(Vx.y[1],Product1.u1)          annotation (points=[-37.1, 69; -37.1,
          73.6; -31.2, 73.6],style(color=3, rgbcolor={0,0,255}));
    connect(Vx.y[1],Product1.u2)          annotation (points=[-37.1, 69; -36,
          69; -36, 66.4; -31.2, 66.4], style(color=3, rgbcolor={0,0,255}));
    connect(Product1.y,Product2.u2)             annotation (points=[-17.4, 70;
          -14, 70; -14, 70.4; -13.2, 70.4], style(color=3, rgbcolor={0,0,255}));
    connect(Atan1.y,Add1.u1[1])          annotation (points=[44.6, 78; 46, 78;
          46, 77.6; 49.2, 77.6], style(color=3, rgbcolor={0,0,255}));
    connect(Product2.y,Gain2.u)             annotation (points=[0.6,74; 6.8,74],
               style(color=3, rgbcolor={0,0,255}));
    connect(Gain2.y,Atan1.u)             annotation (points=[20.6, 74; 23.3, 74;
          23.3, 78; 30.8, 78], style(color=3, rgbcolor={0,0,255}));
    connect(roll_angle.y,Add1.u2)             annotation (points=[-37.1, 53; 44,
          53; 44, 70.4; 49.2, 70.4], style(color=3, rgbcolor={0,0,255}));
    connect(Torque1.flange_b, flange_steer) annotation (points=[110, -70; 110,
          -82; 90, -82; 90, -90], style(color=0, rgbcolor={0,0,0}));
    connect(Vx.u,      Sensor) annotation (points=[-57.8, 69; -90, 69; -90, 30],
        style(color=3, rgbcolor={0,0,255}));
    connect(roll_angle.u,      Sensor) annotation (points=[-57.8, 53; -90, 53;
          -90, 30],style(color=3, rgbcolor={0,0,255}));
    connect(Ct,Product2.u1)       annotation (points=[-90, 90; -13.2, 90; -13.2,
          77.6], style(color=3, rgbcolor={0,0,255}));
    connect(PI1.y,Add3.u1)             annotation (points=[-37.5, 21; -34, 21;
          -34, 12; -32.8, 12], style(color=3, rgbcolor={0,0,255}));
    connect(PI1.u,Add1.y[1])          annotation (points=[-49, 21; -52, 21; -52,
          34; 74, 34; 74, 74; 58.4, 74], style(color=3, rgbcolor={0,0,255}));
    connect(PI4.y,tmp.u)             annotation (points=[12.6, -68; 22.8, -68],
        style(color=3, rgbcolor={0,0,255}));
    connect(PI2.y,Add2.u1)             annotation (points=[-1.5, -7; -1.5, -10.5;
          3.2, -10.5; 3.2, -14.4], style(color=3, rgbcolor={0,0,255}));
    connect(Add3.y,PI2.u)             annotation (points=[-23.6, 9; -16, 9; -16,
          -7; -13, -7],style(color=3, rgbcolor={0,0,255}));
    connect(PI3.y,Add4.u1)             annotation (points=[34.5, -25; 39.2, -25;
          39.2, -32.4],style(color=3, rgbcolor={0,0,255}));
    connect(Add2.y,PI3.u)             annotation (points=[12.4, -18; 16, -18;
          16, -25; 23, -25], style(color=3, rgbcolor={0,0,255}));
    connect(Add4.y,PI4.u)             annotation (points=[48.4,-36; 52,-36; 52,
            -50; -8,-50; -8,-68; -1.2,-68],      style(color=3, rgbcolor={0,0,
            255}));
    connect(Derivative3.y,Add3.u2)             annotation (points=[-51.4, 6; -32.8,
          6], style(color=3, rgbcolor={0,0,255}));
    connect(Derivative3.u,roll_angle.y[1])          annotation (points=[-65.2,
          6; -72, 6; -72, 40; -37.1, 40; -37.1, 53], style(color=3, rgbcolor={0,
            0,255}));
    connect(Derivative3.y,Derivative1.u)             annotation (points=[-51.4,
          6; -48, 6; -48, -10; -56, -10; -56, -20; -49.2, -20], style(color=3,
          rgbcolor={0,0,255}));
    connect(Derivative1.y,Add2.u2)             annotation (points=[-35.4, -20;
          -16, -20; -16, -21.6; 3.2, -21.6], style(color=3, rgbcolor={0,0,255}));
    connect(Derivative1.y,Derivative2.u)             annotation (points=[-35.4,
          -20; -36, -20; -36, -40; -25.2, -40], style(color=3, rgbcolor={0,0,
            255}));
    connect(Derivative2.y,Add4.u2)             annotation (points=[-11.4, -40;
          12, -40; 12, -39.6; 39.2, -39.6], style(color=3, rgbcolor={0,0,255}));
    connect(Non_Linear_Damper1.OUT,Add5.u2[1])    annotation (points=[49, -103;
          54, -103; 54, -75.6; 55.2, -75.6], style(color=3, rgbcolor={0,0,255}));
    connect(roll_angle.y[1],    Non_Linear_Damper1.IN) annotation (points=[-37.1,
          53; -37.1, 40; -72, 40; -72, -85; 31, -85], style(color=3, rgbcolor={
            0,0,255}));
    connect(Derivative1.u,      Non_Linear_Damper1.IN_DER1) annotation (points=
          [-49.2, -20; -48, -20; -48, -89; 31, -89], style(color=3, rgbcolor={0,
            0,255}));
    connect(Derivative2.u,      Non_Linear_Damper1.IN_DER2) annotation (points=
          [-25.2, -40; -28, -40; -28, -94; 31, -94; 31, -93], style(color=3,
          rgbcolor={0,0,255}));
    connect(Add5.y[1],Torque1.tau)        annotation (points=[64.4, -72; 80, -72;
          80, -70; 94.6, -70], style(color=3, rgbcolor={0,0,255}));
    connect(tmp.y,Add5.u1[1])          annotation (points=[36.6, -68; 45.9, -68;
          45.9, -68.4; 55.2, -68.4], style(color=3, rgbcolor={0,0,255}));
  end Steer_Control_PI_style;
    
  model Non_Linear_Damper 
      import Modelica.Constants.*;
      import Modelica.Mechanics.MultiBody.Frames.*;
      import Modelica.Math.*;
    Modelica.Blocks.Interfaces.RealInput IN 
      annotation (extent=[-100, 80; -80, 100]);
    annotation (Diagram);
    parameter Real k1=35;
    parameter Real k2=-20;
    Modelica.Blocks.Interfaces.RealOutput OUT 
      annotation (extent=[80, -100; 100, -80]);
    Modelica.Blocks.Interfaces.RealInput IN_DER1 
      annotation (extent=[-100, 40; -80, 60]);
    Modelica.Blocks.Interfaces.RealInput IN_DER2 
      annotation (extent=[-100, 0; -80, 20]);
  initial algorithm 
    OUT           := 0;
  algorithm 
    OUT           := k1*IN_DER1           + k2*IN_DER2;
    // k1=35 k2=-20
  end Non_Linear_Damper;
    
  model Torque_Sat 
      import Modelica.Constants.*;
      import Modelica.Mechanics.MultiBody.Frames.*;
      import Modelica.Math.*;
    Modelica.Blocks.Interfaces.RealInput IN 
                                         annotation (extent=[-100, 20; -80, 40]);
    annotation (Diagram);
      
    parameter Real k1=1;
    parameter Real k2=1;
    parameter Real k3={1};
    parameter Real k4={1};
    parameter Modelica.SIunits.Time T1=0.5;
    parameter Modelica.SIunits.Time T2=0.5;
    parameter Modelica.SIunits.Time T3=1;
    parameter Modelica.SIunits.Time T4={1};
    Modelica.Blocks.Math.Min Min1 annotation (extent=[-12, 22; -4, 38]);
    Modelica.Blocks.Math.Sign Sign1 annotation (extent=[-10, 44; 0, 54]);
    Modelica.Blocks.Math.Product Product3 annotation (extent=[12, 22; 24, 34]);
    Modelica.Blocks.Sources.Constant Constant1(k=30) 
      annotation (extent=[-52, 36; -42, 48]);
    Modelica.Blocks.Math.Abs Abs1 annotation (extent=[-50, 20; -42, 30]);
    Modelica.Blocks.Interfaces.RealOutput OUT 
                                           annotation (extent=[80, 20; 100, 40]);
  initial algorithm 
    Torque1.tau := 0;
  equation 
    connect(Sign1.y,Product3.u1)             annotation (points=[0.5, 49; 8, 49;
          8, 31.6; 10.8, 31.6], style(color=3, rgbcolor={0,0,255}));
    connect(Min1.y,Product3.u2)             annotation (points=[-3.6,30; 4,30; 4,
            24.4; 10.8,24.4],   style(color=3, rgbcolor={0,0,255}));
    connect(Constant1.y,Min1.u1)             annotation (points=[-41.5, 42; -28,
          42; -28, 34.8; -12.8, 34.8], style(color=3, rgbcolor={0,0,255}));
    connect(Abs1.y,Min1.u2)             annotation (points=[-41.6, 25; -26.8,
          25; -26.8, 25.2; -12.8, 25.2], style(color=3, rgbcolor={0,0,255}));
    connect(IN,Abs1.u)       annotation (points=[-90, 30; -70, 30; -70, 25; -50.8,
          25], style(color=3, rgbcolor={0,0,255}));
    connect(IN,Sign1.u)       annotation (points=[-90, 30; -88, 30; -88, 68; -18,
          68; -18, 49; -11, 49], style(color=3, rgbcolor={0,0,255}));
    connect(Product3.y,       OUT) annotation (points=[24.6, 28; 56, 28; 56, 30;
          90, 30],style(color=3, rgbcolor={0,0,255}));
  end Torque_Sat;
    
  model Path_Table "Table look-up in one dimension (matrix/file) " 
      import Modelica.Math.*;
    parameter Integer n=3 "number of iterations";
    parameter Real table[:, :]=[1.000000, 0.000000, -0.000014, 0.000342, -0.000056,
        0.149997, 0.000988; 2.000000, 0.150000, 0.149983, 0.001330, -0.000106,
        0.149997, 0.000988; 3.000000, 0.300000, 0.299979, 0.002318, -0.000165,
        0.149997, 0.000986; 4.000000, 0.450000, 0.449976, 0.003304, -0.000231,
        0.149997, 0.000984; 5.000000, 0.600000, 0.599973, 0.004288, -0.000302,
        0.149997, 0.000980; 6.000000, 0.750000, 0.749970, 0.005269, -0.000374,
        0.149997, 0.000975; 7.000000, 0.900000, 0.899967, 0.006244, -0.000447,
        0.149997, 0.000968; 8.000000, 1.050000, 1.049963, 0.007212, -0.000520,
        0.149997, 0.000960; 9.000000, 1.200000, 1.199960, 0.008172, -0.000591,
        0.149997, 0.000950; 10.000000, 1.350000, 1.349957, 0.009122, -0.000662,
        0.149997, 0.000938; 11.000000, 1.500000, 1.499954, 0.010061, -0.000731,
        0.149997, 0.000925; 12.000000, 1.650000, 1.649952, 0.010985, -0.000798,
        0.149997, 0.000910; 13.000000, 1.800000, 1.799949, 0.011896, -0.000864,
        0.149997, 0.000894; 14.000000, 1.950000, 1.949946, 0.012789, -0.000929,
        0.149997, 0.000876; 15.000000, 2.100000, 2.099944, 0.013665, -0.000993,
        0.149998, 0.000856; 16.000000, 2.250000, 2.249941, 0.014521, -0.001056,
        0.149998, 0.000835; 17.000000, 2.400000, 2.399939, 0.015356, -0.001118,
        0.149998, 0.000813; 18.000000, 2.550000, 2.549937, 0.016169, -0.001180,
        0.149998, 0.000789; 19.000000, 2.700000, 2.699935, 0.016959, -0.001242,
        0.149998, 0.000764; 20.000000, 2.850000, 2.849933, 0.017723, -0.001304,
        0.149998, 0.000738; 21.000000, 3.000000, 2.999931, 0.018460, -0.001365,
        0.149998, 0.000710; 22.000000, 3.150000, 3.149929, 0.019170, -0.001426,
        0.149998, 0.000680; 23.000000, 3.300000, 3.299928, 0.019850, -0.001488,
        0.149999, 0.000650; 24.000000, 3.450000, 3.449926, 0.020499, -0.001549,
        0.149999, 0.000617; 25.000000, 3.600000, 3.599925, 0.021117, -0.001611,
        0.149999, 0.000584; 26.000000, 3.750000, 3.749924, 0.021701, -0.001672,
        0.149999, 0.000549; 27.000000, 3.900000, 3.899923, 0.022250, -0.001734,
        0.149999, 0.000513; 28.000000, 4.050000, 4.049922, 0.022763, -0.001796,
        0.149999, 0.000475; 29.000000, 4.200000, 4.199921, 0.023238, -0.001857,
        0.149999, 0.000436; 30.000000, 4.350000, 4.349921, 0.023674, -0.001919,
        0.149999, 0.000396; 31.000000, 4.500000, 4.499920, 0.024070, -0.001981,
        0.150000, 0.000354; 32.000000, 4.650000, 4.649920, 0.024424, -0.002042,
        0.150000, 0.000311; 33.000000, 4.800000, 4.799919, 0.024735, -0.002104,
        0.150000, 0.000266; 34.000000, 4.950000, 4.949919, 0.025001, -0.002166,
        0.150000, 0.000220; 35.000000, 5.100000, 5.099919, 0.025222, -0.002227,
        0.150000, 0.000173; 36.000000, 5.250000, 5.249919, 0.025395, -0.002289,
        0.150000, 0.000124; 37.000000, 5.400000, 5.399919, 0.025519, -0.002350,
        0.150000, 0.000074; 38.000000, 5.550000, 5.549919, 0.025593, -0.002411,
        0.150000, 0.000023; 39.000000, 5.700000, 5.699919, 0.025616, -0.002472,
        0.150000, -0.000030; 40.000000, 5.850000, 5.849919, 0.025585, -0.002534,
        0.150000, -0.000084; 41.000000, 6.000000, 5.999919, 0.025501, -0.002595,
        0.150000, -0.000140; 42.000000, 6.150000, 6.149919, 0.025361, -0.002656,
        0.150000, -0.000197; 43.000000, 6.300000, 6.299919, 0.025164, -0.002718,
        0.150000, -0.000256; 44.000000, 6.450000, 6.449918, 0.024908, -0.002780,
        0.150000, -0.000315; 45.000000, 6.600000, 6.599918, 0.024593, -0.002842,
        0.150000, -0.000376; 46.000000, 6.750000, 6.749918, 0.024216, -0.002905,
        0.149999, -0.000439; 47.000000, 6.900000, 6.899917, 0.023777, -0.002969,
        0.149999, -0.000503; 48.000000, 7.050000, 7.049916, 0.023275, -0.003034,
        0.149999, -0.000568; 49.000000, 7.200000, 7.199915, 0.022706, -0.003100,
        0.149999, -0.000635; 50.000000, 7.350000, 7.349914, 0.022071, -0.003168,
        0.149998, -0.000703; 51.000000, 7.500000, 7.499912, 0.021368, -0.003237,
        0.149998, -0.000773; 52.000000, 7.650000, 7.649910, 0.020595, -0.003308,
        0.149998, -0.000844; 53.000000, 7.800000, 7.799908, 0.019751, -0.003381,
        0.149997, -0.000917; 54.000000, 7.950000, 7.949905, 0.018833, -0.003455,
        0.149997, -0.000992; 55.000000, 8.100000, 8.099902, 0.017842, -0.003528,
        0.149996, -0.001068; 56.000000, 8.250000, 8.249898, 0.016774, -0.003601,
        0.149996, -0.001145; 57.000000, 8.400000, 8.399893, 0.015629, -0.003672,
        0.149995, -0.001225; 58.000000, 8.550000, 8.549888, 0.014404, -0.003737,
        0.149994, -0.001306; 59.000000, 8.700000, 8.699883, 0.013098, -0.003795,
        0.149994, -0.001388; 60.000000, 8.850000, 8.849876, 0.011710, -0.003842,
        0.149993, -0.001473; 61.000000, 9.000000, 8.999869, 0.010237, -0.003872,
        0.149992, -0.001558; 62.000000, 9.150000, 9.149861, 0.008679, -0.003882,
        0.149991, -0.001644; 63.000000, 9.300000, 9.299852, 0.007035, -0.003866,
        0.149990, -0.001731; 64.000000, 9.450000, 9.449841, 0.005303, -0.003819,
        0.149989, -0.001819; 65.000000, 9.600000, 9.599830, 0.003484, -0.003737,
        0.149988, -0.001906; 66.000000, 9.750000, 9.749818, 0.001579, -0.003617,
        0.149987, -0.001992; 67.000000, 9.900000, 9.899805, -0.000413, -0.003459,
        0.149985, -0.002076; 68.000000, 10.050000, 10.049790, -0.002489, -0.003264,
        0.149984, -0.002157; 69.000000, 10.200000, 10.199774, -0.004646, -0.003037,
        0.149983, -0.002235; 70.000000, 10.350000, 10.349758, -0.006881, -0.002782,
        0.149982, -0.002308; 71.000000, 10.500000, 10.499740, -0.009189, -0.002505,
        0.149981, -0.002377; 72.000000, 10.650000, 10.649721, -0.011566, -0.002211,
        0.149980, -0.002439; 73.000000, 10.800000, 10.799701, -0.014006, -0.001904,
        0.149979, -0.002496; 74.000000, 10.950000, 10.949680, -0.016501, -0.001588,
        0.149978, -0.002545; 75.000000, 11.100000, 11.099659, -0.019047, -0.001266,
        0.149978, -0.002588; 76.000000, 11.250000, 11.249636, -0.021635, -0.000941,
        0.149977, -0.002624; 77.000000, 11.400000, 11.399614, -0.024259, -0.000615,
        0.149977, -0.002652; 78.000000, 11.550000, 11.549590, -0.026911, -0.000289,
        0.149976, -0.002674; 79.000000, 11.700000, 11.699567, -0.029585,
        0.000036, 0.149976, -0.002687; 80.000000, 11.850000, 11.849543, -0.032272,
        0.000360, 0.149976, -0.002694; 81.000000, 12.000000, 11.999519, -0.034966,
        0.000683, 0.149976, -0.002693; 82.000000, 12.150000, 12.149494, -0.037660,
        0.001003, 0.149976, -0.002685; 83.000000, 12.300000, 12.299471, -0.040345,
        0.001322, 0.149976, -0.002670; 84.000000, 12.450000, 12.449447, -0.043014,
        0.001640, 0.149977, -0.002647; 85.000000, 12.600000, 12.599424, -0.045661,
        0.001957, 0.149977, -0.002617; 86.000000, 12.750000, 12.749401, -0.048279,
        0.002272, 0.149978, -0.002580; 87.000000, 12.900000, 12.899379, -0.050859,
        0.002588, 0.149979, -0.002536; 88.000000, 13.050000, 13.049358, -0.053396,
        0.002902, 0.149980, -0.002485; 89.000000, 13.200000, 13.199337, -0.055881,
        0.003216, 0.149980, -0.002427; 90.000000, 13.350000, 13.349318, -0.058308,
        0.003530, 0.149982, -0.002362; 91.000000, 13.500000, 13.499299, -0.060670,
        0.003844, 0.149983, -0.002289; 92.000000, 13.650000, 13.649282, -0.062959,
        0.004159, 0.149984, -0.002210; 93.000000, 13.800000, 13.799266, -0.065170,
        0.004473, 0.149985, -0.002124; 94.000000, 13.950000, 13.949251, -0.067293,
        0.004787, 0.149986, -0.002030; 95.000000, 14.100000, 14.099237, -0.069323,
        0.005102, 0.149988, -0.001929; 96.000000, 14.250000, 14.249225, -0.071252,
        0.005416, 0.149989, -0.001822; 97.000000, 14.400000, 14.399214, -0.073074,
        0.005731, 0.149990, -0.001707; 98.000000, 14.550000, 14.549204, -0.074781,
        0.006046, 0.149992, -0.001585; 99.000000, 14.700000, 14.699196, -0.076366,
        0.006361, 0.149993, -0.001456; 100.000000, 14.850000, 14.849189, -0.077822,
        0.006677, 0.149994, -0.001320; 101.000000, 15.000000, 14.999184, -0.079142,
        0.006992, 0.149996, -0.001177; 102.000000, 15.150000, 15.149179, -0.080319,
        0.007308, 0.149997, -0.001027; 103.000000, 15.300000, 15.299176, -0.081346,
        0.007623, 0.149998, -0.000869; 104.000000, 15.450000, 15.449173, -0.082215,
        0.007939, 0.149998, -0.000705; 105.000000, 15.600000, 15.599172, -0.082920,
        0.008255, 0.149999, -0.000533; 106.000000, 15.750000, 15.749171, -0.083454,
        0.008570, 0.150000, -0.000355; 107.000000, 15.900000, 15.899171, -0.083808,
        0.008886, 0.150000, -0.000169; 108.000000, 16.050000, 16.049171, -0.083977,
        0.009203, 0.150000, 0.000024; 109.000000, 16.200000, 16.199171, -0.083954,
        0.009519, 0.150000, 0.000224; 110.000000, 16.350000, 16.349171, -0.083730,
        0.009837, 0.150000, 0.000431; 111.000000, 16.500000, 16.499170, -0.083299,
        0.010155, 0.149999, 0.000645; 112.000000, 16.650000, 16.649169, -0.082654,
        0.010474, 0.149998, 0.000866; 113.000000, 16.800000, 16.799167, -0.081788,
        0.010794, 0.149996, 0.001095; 114.000000, 16.950000, 16.949163, -0.080693,
        0.011116, 0.149994, 0.001330; 115.000000, 17.100000, 17.099157, -0.079363,
        0.011441, 0.149992, 0.001573; 116.000000, 17.250000, 17.249149, -0.077790,
        0.011768, 0.149989, 0.001823; 117.000000, 17.400000, 17.399138, -0.075966,
        0.012097, 0.149986, 0.002081; 118.000000, 17.550000, 17.549124, -0.073886,
        0.012430, 0.149982, 0.002345; 119.000000, 17.700000, 17.699106, -0.071540,
        0.012765, 0.149977, 0.002618; 120.000000, 17.850000, 17.849083, -0.068923,
        0.013103, 0.149972, 0.002897; 121.000000, 18.000000, 17.999056, -0.066025,
        0.013442, 0.149966, 0.003184; 122.000000, 18.150000, 18.149022, -0.062841,
        0.013781, 0.149960, 0.003479; 123.000000, 18.300000, 18.298982, -0.059362,
        0.014118, 0.149952, 0.003782; 124.000000, 18.450000, 18.448934, -0.055580,
        0.014449, 0.149944, 0.004091; 125.000000, 18.600000, 18.598878, -0.051489,
        0.014771, 0.149935, 0.004409; 126.000000, 18.750000, 18.748813, -0.047080,
        0.015077, 0.149925, 0.004734; 127.000000, 18.900000, 18.898738, -0.042346,
        0.015362, 0.149914, 0.005066; 128.000000, 19.050000, 19.048651, -0.037280,
        0.015618, 0.149902, 0.005405; 129.000000, 19.200000, 19.198553, -0.031874,
        0.015835, 0.149889, 0.005751; 130.000000, 19.350000, 19.348442, -0.026124,
        0.016006, 0.149875, 0.006102; 131.000000, 19.500000, 19.498317, -0.020022,
        0.016122, 0.149860, 0.006458; 132.000000, 19.650000, 19.648176, -0.013565,
        0.016176, 0.149844, 0.006817; 133.000000, 19.800000, 19.798020, -0.006747,
        0.016165, 0.149827, 0.007180; 134.000000, 19.950000, 19.947847,
        0.000433, 0.016088, 0.149809, 0.007543; 135.000000, 20.100000,
        20.097656, 0.007976, 0.015952, 0.149790, 0.007907; 136.000000,
        20.250000, 20.247446, 0.015882, 0.015764, 0.149771, 0.008268;
        137.000000, 20.400000, 20.397216, 0.024150, 0.015531, 0.149751,
        0.008626; 138.000000, 20.550000, 20.546967, 0.032777, 0.015263,
        0.149730, 0.008980; 139.000000, 20.700000, 20.696697, 0.041757,
        0.014968, 0.149709, 0.009329; 140.000000, 20.850000, 20.846406,
        0.051086, 0.014654, 0.149687, 0.009672; 141.000000, 21.000000,
        20.996093, 0.060758, 0.014326, 0.149665, 0.010008; 142.000000,
        21.150000, 21.145758, 0.070766, 0.013990, 0.149643, 0.010337;
        143.000000, 21.300000, 21.295401, 0.081103, 0.013650, 0.149621,
        0.010659; 144.000000, 21.450000, 21.445022, 0.091762, 0.013308,
        0.149598, 0.010973; 145.000000, 21.600000, 21.594620, 0.102734,
        0.012967, 0.149575, 0.011279; 146.000000, 21.750000, 21.744195,
        0.114013, 0.012627, 0.149553, 0.011577; 147.000000, 21.900000,
        21.893748, 0.125591, 0.012290, 0.149530, 0.011868; 148.000000,
        22.050000, 22.043277, 0.137459, 0.011956, 0.149507, 0.012151;
        149.000000, 22.200000, 22.192785, 0.149610, 0.011624, 0.149485,
        0.012427; 150.000000, 22.350000, 22.342269, 0.162037, 0.011296,
        0.149462, 0.012695; 151.000000, 22.500000, 22.491731, 0.174732,
        0.010970, 0.149440, 0.012956; 152.000000, 22.650000, 22.641171,
        0.187688, 0.010645, 0.149418, 0.013209; 153.000000, 22.800000,
        22.790588, 0.200897, 0.010323, 0.149396, 0.013455; 154.000000,
        22.950000, 22.939984, 0.214352, 0.010001, 0.149374, 0.013693;
        155.000000, 23.100000, 23.089358, 0.228045, 0.009681, 0.149352,
        0.013925; 156.000000, 23.250000, 23.238710, 0.241970, 0.009362,
        0.149331, 0.014149; 157.000000, 23.400000, 23.388042, 0.256118,
        0.009042, 0.149311, 0.014365; 158.000000, 23.550000, 23.537352,
        0.270484, 0.008724, 0.149290, 0.014575; 159.000000, 23.700000,
        23.686643, 0.285059, 0.008405, 0.149270, 0.014778; 160.000000,
        23.850000, 23.835913, 0.299836, 0.008087, 0.149251, 0.014973;
        161.000000, 24.000000, 23.985164, 0.314809, 0.007769, 0.149232,
        0.015161; 162.000000, 24.150000, 24.134396, 0.329970, 0.007451,
        0.149213, 0.015342; 163.000000, 24.300000, 24.283610, 0.345312,
        0.007133, 0.149195, 0.015516; 164.000000, 24.450000, 24.432805,
        0.360828, 0.006815, 0.149178, 0.015683; 165.000000, 24.600000,
        24.581983, 0.376511, 0.006497, 0.149161, 0.015842; 166.000000,
        24.750000, 24.731144, 0.392353, 0.006179, 0.149145, 0.015995;
        167.000000, 24.900000, 24.880289, 0.408348, 0.005861, 0.149129,
        0.016140; 168.000000, 25.050000, 25.029419, 0.424488, 0.005544,
        0.149114, 0.016278; 169.000000, 25.200000, 25.178533, 0.440766,
        0.005226, 0.149100, 0.016409; 170.000000, 25.350000, 25.327633,
        0.457175, 0.004909, 0.149086, 0.016533; 171.000000, 25.500000,
        25.476719, 0.473709, 0.004592, 0.149073, 0.016650; 172.000000,
        25.650000, 25.625792, 0.490359, 0.004275, 0.149061, 0.016760;
        173.000000, 25.800000, 25.774853, 0.507119, 0.003958, 0.149049,
        0.016863; 174.000000, 25.950000, 25.923902, 0.523981, 0.003642,
        0.149038, 0.016958; 175.000000, 26.100000, 26.072941, 0.540939,
        0.003325, 0.149028, 0.017047; 176.000000, 26.250000, 26.221969,
        0.557986, 0.003009, 0.149019, 0.017128; 177.000000, 26.400000,
        26.370988, 0.575114, 0.002692, 0.149010, 0.017202; 178.000000,
        26.550000, 26.519998, 0.592317, 0.002375, 0.149003, 0.017270;
        179.000000, 26.700000, 26.669001, 0.609586, 0.002057, 0.148996,
        0.017330; 180.000000, 26.850000, 26.817997, 0.626916, 0.001739,
        0.148990, 0.017383; 181.000000, 27.000000, 26.966986, 0.644299,
        0.001420, 0.148984, 0.017429; 182.000000, 27.150000, 27.115971,
        0.661728, 0.001099, 0.148980, 0.017468; 183.000000, 27.300000,
        27.264950, 0.679196, 0.000777, 0.148976, 0.017499; 184.000000,
        27.450000, 27.413926, 0.696695, 0.000454, 0.148973, 0.017524;
        185.000000, 27.600000, 27.562899, 0.714219, 0.000128, 0.148971,
        0.017541; 186.000000, 27.750000, 27.711870, 0.731760, -0.000199,
        0.148970, 0.017552; 187.000000, 27.900000, 27.860840, 0.749312, -0.000527,
        0.148969, 0.017554; 188.000000, 28.050000, 28.009809, 0.766866, -0.000857,
        0.148970, 0.017550; 189.000000, 28.200000, 28.158779, 0.784416, -0.001187,
        0.148971, 0.017538; 190.000000, 28.350000, 28.307750, 0.801954, -0.001515,
        0.148974, 0.017519; 191.000000, 28.500000, 28.456724, 0.819473, -0.001840,
        0.148977, 0.017492; 192.000000, 28.650000, 28.605701, 0.836966, -0.002158,
        0.148981, 0.017459; 193.000000, 28.800000, 28.754681, 0.854425, -0.002468,
        0.148985, 0.017418; 194.000000, 28.950000, 28.903667, 0.871842, -0.002764,
        0.148991, 0.017369; 195.000000, 29.100000, 29.052658, 0.889211, -0.003042,
        0.148997, 0.017314; 196.000000, 29.250000, 29.201655, 0.906526, -0.003296,
        0.149005, 0.017252; 197.000000, 29.400000, 29.350659, 0.923778, -0.003522,
        0.149012, 0.017184; 198.000000, 29.550000, 29.499672, 0.940962, -0.003713,
        0.149021, 0.017111; 199.000000, 29.700000, 29.648693, 0.958073, -0.003866,
        0.149030, 0.017032; 200.000000, 29.850000, 29.797722, 0.975105, -0.003977,
        0.149039, 0.016949; 201.000000, 30.000000, 29.946762, 0.992054, -0.004049,
        0.149049, 0.016863; 202.000000, 30.150000, 30.095811, 1.008916, -0.004082,
        0.149059, 0.016774; 203.000000, 30.300000, 30.244870, 1.025690, -0.004083,
        0.149069, 0.016683; 204.000000, 30.450000, 30.393939, 1.042373, -0.004057,
        0.149079, 0.016592; 205.000000, 30.600000, 30.543018, 1.058965, -0.004008,
        0.149090, 0.016500; 206.000000, 30.750000, 30.692108, 1.075465, -0.003942,
        0.149100, 0.016410; 207.000000, 30.900000, 30.841207, 1.091875, -0.003865,
        0.149109, 0.016320; 208.000000, 31.050000, 30.990317, 1.108195, -0.003778,
        0.149119, 0.016232; 209.000000, 31.200000, 31.139436, 1.124427, -0.003687,
        0.149128, 0.016145; 210.000000, 31.350000, 31.288564, 1.140573, -0.003592,
        0.149138, 0.016061; 211.000000, 31.500000, 31.437702, 1.156634, -0.003497,
        0.149146, 0.015979; 212.000000, 31.650000, 31.586848, 1.172612, -0.003402,
        0.149155, 0.015898; 213.000000, 31.800000, 31.736003, 1.188510, -0.003308,
        0.149163, 0.015820; 214.000000, 31.950000, 31.885167, 1.204330, -0.003216,
        0.149171, 0.015744; 215.000000, 32.100000, 32.034338, 1.220074, -0.003125,
        0.149179, 0.015670; 216.000000, 32.250000, 32.183518, 1.235744, -0.003036,
        0.149187, 0.015598; 217.000000, 32.400000, 32.332704, 1.251341, -0.002949,
        0.149194, 0.015528; 218.000000, 32.550000, 32.481899, 1.266869, -0.002863,
        0.149201, 0.015460; 219.000000, 32.700000, 32.631100, 1.282329, -0.002778,
        0.149208, 0.015394; 220.000000, 32.850000, 32.780308, 1.297723, -0.002695,
        0.149215, 0.015330; 221.000000, 33.000000, 32.929522, 1.313053, -0.002612,
        0.149221, 0.015268; 222.000000, 33.150000, 33.078743, 1.328320, -0.002529,
        0.149227, 0.015207; 223.000000, 33.300000, 33.227971, 1.343528, -0.002447,
        0.149233, 0.015149; 224.000000, 33.450000, 33.377204, 1.358676, -0.002365,
        0.149239, 0.015092; 225.000000, 33.600000, 33.526442, 1.373769, -0.002283,
        0.149244, 0.015037; 226.000000, 33.750000, 33.675687, 1.388806, -0.002201,
        0.149250, 0.014984; 227.000000, 33.900000, 33.824937, 1.403791, -0.002119,
        0.149255, 0.014933; 228.000000, 34.050000, 33.974191, 1.418724, -0.002038,
        0.149260, 0.014884; 229.000000, 34.200000, 34.123451, 1.433608, -0.001956,
        0.149264, 0.014837; 230.000000, 34.350000, 34.272716, 1.448445, -0.001873,
        0.149269, 0.014791; 231.000000, 34.500000, 34.421984, 1.463236, -0.001791,
        0.149273, 0.014747; 232.000000, 34.650000, 34.571258, 1.477983, -0.001709,
        0.149277, 0.014705; 233.000000, 34.800000, 34.720535, 1.492688, -0.001627,
        0.149281, 0.014665; 234.000000, 34.950000, 34.869817, 1.507353, -0.001544,
        0.149285, 0.014627; 235.000000, 35.100000, 35.019102, 1.521980, -0.001462,
        0.149289, 0.014590; 236.000000, 35.250000, 35.168391, 1.536571, -0.001380,
        0.149292, 0.014556; 237.000000, 35.400000, 35.317683, 1.551126, -0.001297,
        0.149295, 0.014523; 238.000000, 35.550000, 35.466978, 1.565650, -0.001215,
        0.149298, 0.014492; 239.000000, 35.700000, 35.616276, 1.580142, -0.001133,
        0.149301, 0.014463; 240.000000, 35.850000, 35.765577, 1.594605, -0.001050,
        0.149304, 0.014436; 241.000000, 36.000000, 35.914881, 1.609041, -0.000968,
        0.149306, 0.014411; 242.000000, 36.150000, 36.064187, 1.623452, -0.000885,
        0.149308, 0.014387; 243.000000, 36.300000, 36.213496, 1.637839, -0.000803,
        0.149311, 0.014365; 244.000000, 36.450000, 36.362806, 1.652204, -0.000720,
        0.149312, 0.014346; 245.000000, 36.600000, 36.512119, 1.666550, -0.000638,
        0.149314, 0.014328; 246.000000, 36.750000, 36.661433, 1.680877, -0.000555,
        0.149316, 0.014311; 247.000000, 36.900000, 36.810749, 1.695189, -0.000472,
        0.149317, 0.014297; 248.000000, 37.050000, 36.960066, 1.709486, -0.000388,
        0.149318, 0.014285; 249.000000, 37.200000, 37.109384, 1.723771, -0.000305,
        0.149319, 0.014274; 250.000000, 37.350000, 37.258703, 1.738045, -0.000221,
        0.149320, 0.014266; 251.000000, 37.500000, 37.408023, 1.752310, -0.000136,
        0.149321, 0.014259; 252.000000, 37.650000, 37.557344, 1.766569, -0.000051,
        0.149321, 0.014254; 253.000000, 37.800000, 37.706665, 1.780823,
        0.000034, 0.149322, 0.014251; 254.000000, 37.950000, 37.855987,
        1.795074, 0.000120, 0.149322, 0.014250; 255.000000, 38.100000,
        38.005309, 1.809323, 0.000206, 0.149322, 0.014250; 256.000000,
        38.250000, 38.154630, 1.823573, 0.000292, 0.149321, 0.014253;
        257.000000, 38.400000, 38.303951, 1.837826, 0.000377, 0.149321,
        0.014258; 258.000000, 38.550000, 38.453272, 1.852084, 0.000462,
        0.149320, 0.014264; 259.000000, 38.700000, 38.602593, 1.866348,
        0.000545, 0.149319, 0.014273; 260.000000, 38.850000, 38.751912,
        1.880621, 0.000626, 0.149318, 0.014283; 261.000000, 39.000000,
        38.901230, 1.894903, 0.000703, 0.149317, 0.014295; 262.000000,
        39.150000, 39.050548, 1.909199, 0.000775, 0.149316, 0.014309;
        263.000000, 39.300000, 39.199864, 1.923508, 0.000842, 0.149314,
        0.014325; 264.000000, 39.450000, 39.349178, 1.937833, 0.000901,
        0.149313, 0.014342; 265.000000, 39.600000, 39.498491, 1.952175,
        0.000951, 0.149311, 0.014361; 266.000000, 39.750000, 39.647802,
        1.966536, 0.000990, 0.149309, 0.014381; 267.000000, 39.900000,
        39.797111, 1.980917, 0.001020, 0.149307, 0.014403; 268.000000,
        40.050000, 39.946418, 1.995320, 0.001039, 0.149305, 0.014425;
        269.000000, 40.200000, 40.095723, 2.009744, 0.001048, 0.149303,
        0.014448; 270.000000, 40.350000, 40.245025, 2.024192, 0.001048,
        0.149300, 0.014471; 271.000000, 40.500000, 40.394325, 2.038663,
        0.001042, 0.149298, 0.014494; 272.000000, 40.650000, 40.543624,
        2.053157, 0.001029, 0.149296, 0.014518; 273.000000, 40.800000,
        40.692919, 2.067675, 0.001013, 0.149294, 0.014541; 274.000000,
        40.950000, 40.842213, 2.082216, 0.000993, 0.149291, 0.014564;
        275.000000, 41.100000, 40.991504, 2.096780, 0.000971, 0.149289,
        0.014587; 276.000000, 41.250000, 41.140793, 2.111367, 0.000948,
        0.149287, 0.014609; 277.000000, 41.400000, 41.290080, 2.125976,
        0.000923, 0.149285, 0.014631; 278.000000, 41.550000, 41.439365,
        2.140607, 0.000899, 0.149283, 0.014652; 279.000000, 41.700000,
        41.588647, 2.155259, 0.000875, 0.149281, 0.014673; 280.000000,
        41.850000, 41.737928, 2.169931, 0.000851, 0.149279, 0.014693;
        281.000000, 42.000000, 41.887207, 2.184624, 0.000827, 0.149277,
        0.014712; 282.000000, 42.150000, 42.036484, 2.199337, 0.000804,
        0.149275, 0.014731; 283.000000, 42.300000, 42.185758, 2.214068,
        0.000782, 0.149273, 0.014750; 284.000000, 42.450000, 42.335031,
        2.228818, 0.000760, 0.149271, 0.014768; 285.000000, 42.600000,
        42.484303, 2.243586, 0.000738, 0.149270, 0.014786; 286.000000,
        42.750000, 42.633572, 2.258372, 0.000716, 0.149268, 0.014803;
        287.000000, 42.900000, 42.782840, 2.273174, 0.000695, 0.149266,
        0.014819; 288.000000, 43.050000, 42.932106, 2.287993, 0.000674,
        0.149265, 0.014835; 289.000000, 43.200000, 43.081371, 2.302828,
        0.000653, 0.149263, 0.014851; 290.000000, 43.350000, 43.230634,
        2.317679, 0.000632, 0.149262, 0.014866; 291.000000, 43.500000,
        43.379895, 2.332544, 0.000611, 0.149260, 0.014880; 292.000000,
        43.650000, 43.529156, 2.347425, 0.000591, 0.149259, 0.014894;
        293.000000, 43.800000, 43.678414, 2.362319, 0.000570, 0.149257,
        0.014908; 294.000000, 43.950000, 43.827672, 2.377228, 0.000549,
        0.149256, 0.014921; 295.000000, 44.100000, 43.976928, 2.392149,
        0.000528, 0.149255, 0.014934; 296.000000, 44.250000, 44.126182,
        2.407083, 0.000508, 0.149253, 0.014946; 297.000000, 44.400000,
        44.275436, 2.422030, 0.000487, 0.149252, 0.014958; 298.000000,
        44.550000, 44.424688, 2.436988, 0.000466, 0.149251, 0.014970;
        299.000000, 44.700000, 44.573939, 2.451957, 0.000445, 0.149250,
        0.014981; 300.000000, 44.850000, 44.723189, 2.466938, 0.000425,
        0.149249, 0.014991; 301.000000, 45.000000, 44.872438, 2.481929,
        0.000404, 0.149248, 0.015001; 302.000000, 45.150000, 45.021686,
        2.496930, 0.000383, 0.149247, 0.015010; 303.000000, 45.300000,
        45.170933, 2.511940, 0.000362, 0.149246, 0.015020; 304.000000,
        45.450000, 45.320179, 2.526960, 0.000341, 0.149245, 0.015028;
        305.000000, 45.600000, 45.469425, 2.541988, 0.000320, 0.149244,
        0.015036; 306.000000, 45.750000, 45.618669, 2.557024, 0.000300,
        0.149244, 0.015044; 307.000000, 45.900000, 45.767913, 2.572068,
        0.000279, 0.149243, 0.015051; 308.000000, 46.050000, 45.917156,
        2.587119, 0.000258, 0.149242, 0.015058; 309.000000, 46.200000,
        46.066398, 2.602177, 0.000237, 0.149242, 0.015064; 310.000000,
        46.350000, 46.215640, 2.617241, 0.000216, 0.149241, 0.015070;
        311.000000, 46.500000, 46.364881, 2.632311, 0.000195, 0.149241,
        0.015075; 312.000000, 46.650000, 46.514122, 2.647386, 0.000175,
        0.149240, 0.015080; 313.000000, 46.800000, 46.663362, 2.662465,
        0.000154, 0.149240, 0.015084; 314.000000, 46.950000, 46.812601,
        2.677550, 0.000133, 0.149239, 0.015088; 315.000000, 47.100000,
        46.961840, 2.692638, 0.000112, 0.149239, 0.015092; 316.000000,
        47.250000, 47.111079, 2.707729, 0.000090, 0.149239, 0.015095;
        317.000000, 47.400000, 47.260318, 2.722824, 0.000069, 0.149238,
        0.015097; 318.000000, 47.550000, 47.409556, 2.737921, 0.000048,
        0.149238, 0.015099; 319.000000, 47.700000, 47.558794, 2.753020,
        0.000027, 0.149238, 0.015101; 320.000000, 47.850000, 47.708032,
        2.768121, 0.000005, 0.149238, 0.015102; 321.000000, 48.000000,
        47.857270, 2.783222, -0.000017, 0.149238, 0.015102; 322.000000,
        48.150000, 48.006508, 2.798325, -0.000038, 0.149238, 0.015102;
        323.000000, 48.300000, 48.155746, 2.813427, -0.000060, 0.149238,
        0.015102; 324.000000, 48.450000, 48.304984, 2.828529, -0.000082,
        0.149238, 0.015101; 325.000000, 48.600000, 48.454222, 2.843630, -0.000103,
        0.149238, 0.015100; 326.000000, 48.750000, 48.603460, 2.858730, -0.000124,
        0.149238, 0.015098; 327.000000, 48.900000, 48.752698, 2.873828, -0.000144,
        0.149238, 0.015096; 328.000000, 49.050000, 48.901936, 2.888924, -0.000164,
        0.149239, 0.015093; 329.000000, 49.200000, 49.051175, 2.904017, -0.000182,
        0.149239, 0.015090; 330.000000, 49.350000, 49.200414, 2.919107, -0.000199,
        0.149239, 0.015086; 331.000000, 49.500000, 49.349654, 2.934193, -0.000214,
        0.149240, 0.015082; 332.000000, 49.650000, 49.498893, 2.949275, -0.000227,
        0.149240, 0.015078; 333.000000, 49.800000, 49.648134, 2.964352, -0.000238,
        0.149241, 0.015073; 334.000000, 49.950000, 49.797375, 2.979425, -0.000246,
        0.149241, 0.015068; 335.000000, 50.100000, 49.946616, 2.994493, -0.000252,
        0.149242, 0.015062; 336.000000, 50.250000, 50.095858, 3.009555, -0.000255,
        0.149242, 0.015057; 337.000000, 50.400000, 50.245100, 3.024612, -0.000256,
        0.149243, 0.015051; 338.000000, 50.550000, 50.394343, 3.039663, -0.000255,
        0.149244, 0.015045; 339.000000, 50.700000, 50.543587, 3.054708, -0.000253,
        0.149244, 0.015040; 340.000000, 50.850000, 50.692831, 3.069748, -0.000250,
        0.149245, 0.015034; 341.000000, 51.000000, 50.842075, 3.084782, -0.000246,
        0.149245, 0.015028; 342.000000, 51.150000, 50.991321, 3.099810, -0.000242,
        0.149246, 0.015023; 343.000000, 51.300000, 51.140566, 3.114833, -0.000237,
        0.149246, 0.015017; 344.000000, 51.450000, 51.289813, 3.129850, -0.000233,
        0.149247, 0.015012; 345.000000, 51.600000, 51.439060, 3.144862, -0.000228,
        0.149247, 0.015006; 346.000000, 51.750000, 51.588307, 3.159869, -0.000223,
        0.149248, 0.015001; 347.000000, 51.900000, 51.737555, 3.174870, -0.000218,
        0.149248, 0.014996; 348.000000, 52.050000, 51.886804, 3.189866, -0.000213,
        0.149249, 0.014991; 349.000000, 52.200000, 52.036053, 3.204857, -0.000209,
        0.149249, 0.014986; 350.000000, 52.350000, 52.185302, 3.219844, -0.000204,
        0.149250, 0.014982; 351.000000, 52.500000, 52.334552, 3.234825, -0.000200,
        0.149250, 0.014977; 352.000000, 52.650000, 52.483803, 3.249802, -0.000196,
        0.149251, 0.014972; 353.000000, 52.800000, 52.633054, 3.264774, -0.000192,
        0.149251, 0.014968; 354.000000, 52.950000, 52.782305, 3.279742, -0.000187,
        0.149252, 0.014963; 355.000000, 53.100000, 52.931557, 3.294705, -0.000183,
        0.149252, 0.014959; 356.000000, 53.250000, 53.080809, 3.309665, -0.000179,
        0.149253, 0.014955; 357.000000, 53.400000, 53.230062, 3.324619, -0.000175,
        0.149253, 0.014951; 358.000000, 53.550000, 53.379315, 3.339570, -0.000171,
        0.149253, 0.014947; 359.000000, 53.700000, 53.528568, 3.354517, -0.000167,
        0.149254, 0.014943; 360.000000, 53.850000, 53.677822, 3.369460, -0.000163,
        0.149254, 0.014939; 361.000000, 54.000000, 53.827076, 3.384399, -0.000159,
        0.149255, 0.014935; 362.000000, 54.150000, 53.976331, 3.399334, -0.000155,
        0.149255, 0.014932; 363.000000, 54.300000, 54.125586, 3.414266, -0.000151,
        0.149255, 0.014928; 364.000000, 54.450000, 54.274841, 3.429194, -0.000147,
        0.149256, 0.014925; 365.000000, 54.600000, 54.424097, 3.444119, -0.000143,
        0.149256, 0.014921; 366.000000, 54.750000, 54.573353, 3.459040, -0.000139,
        0.149256, 0.014918; 367.000000, 54.900000, 54.722609, 3.473958, -0.000135,
        0.149257, 0.014915; 368.000000, 55.050000, 54.871866, 3.488873, -0.000131,
        0.149257, 0.014912; 369.000000, 55.200000, 55.021123, 3.503784, -0.000127,
        0.149257, 0.014909; 370.000000, 55.350000, 55.170380, 3.518693, -0.000123,
        0.149258, 0.014906; 371.000000, 55.500000, 55.319637, 3.533598, -0.000119,
        0.149258, 0.014903; 372.000000, 55.650000, 55.468895, 3.548501, -0.000115,
        0.149258, 0.014900; 373.000000, 55.800000, 55.618153, 3.563401, -0.000111,
        0.149258, 0.014897; 374.000000, 55.950000, 55.767412, 3.578299, -0.000107,
        0.149259, 0.014895; 375.000000, 56.100000, 55.916671, 3.593194, -0.000103,
        0.149259, 0.014892; 376.000000, 56.250000, 56.065929, 3.608086, -0.000099,
        0.149259, 0.014890; 377.000000, 56.400000, 56.215189, 3.622976, -0.000095,
        0.149259, 0.014888; 378.000000, 56.550000, 56.364448, 3.637864, -0.000091,
        0.149260, 0.014885; 379.000000, 56.700000, 56.513707, 3.652749, -0.000087,
        0.149260, 0.014883; 380.000000, 56.850000, 56.662967, 3.667632, -0.000083,
        0.149260, 0.014881; 381.000000, 57.000000, 56.812227, 3.682514, -0.000079,
        0.149260, 0.014879; 382.000000, 57.150000, 56.961487, 3.697393, -0.000075,
        0.149260, 0.014878; 383.000000, 57.300000, 57.110748, 3.712270, -0.000071,
        0.149261, 0.014876; 384.000000, 57.450000, 57.260008, 3.727146, -0.000066,
        0.149261, 0.014874; 385.000000, 57.600000, 57.409269, 3.742020, -0.000062,
        0.149261, 0.014872; 386.000000, 57.750000, 57.558530, 3.756893, -0.000058,
        0.149261, 0.014871; 387.000000, 57.900000, 57.707791, 3.771764, -0.000054,
        0.149261, 0.014870; 388.000000, 58.050000, 57.857052, 3.786633, -0.000049,
        0.149261, 0.014868; 389.000000, 58.200000, 58.006313, 3.801502, -0.000045,
        0.149261, 0.014867; 390.000000, 58.350000, 58.155575, 3.816369, -0.000040,
        0.149262, 0.014866; 391.000000, 58.500000, 58.304836, 3.831235, -0.000035,
        0.149262, 0.014865; 392.000000, 58.650000, 58.454098, 3.846100, -0.000030,
        0.149262, 0.014864; 393.000000, 58.800000, 58.603360, 3.860964, -0.000025,
        0.149262, 0.014863; 394.000000, 58.950000, 58.752622, 3.875827, -0.000020,
        0.149262, 0.014863; 395.000000, 59.100000, 58.901883, 3.890690, -0.000015,
        0.149262, 0.014862; 396.000000, 59.250000, 59.051145, 3.905552, -0.000011,
        0.149262, 0.014862; 397.000000, 59.400000, 59.200407, 3.920414, -0.000007,
        0.149262, 0.014861; 398.000000, 59.550000, 59.349669, 3.935275, -0.000003,
        0.149262, 0.014861; 399.000000, 59.700000, 59.498931, 3.950136,
        0.000000, 0.149262, 0.014861; 400.000000, 59.850000, 59.648193,
        3.964997, 0.000000, 0.149262, 0.014861; 401.000000, 60.000000,
        59.797455, 3.979858, 0.000000, 0.149262, 0.014861] 
        "table matrix (grid = first column)" 
                                           annotation (Evaluate=false);
    Real delta_s[2];
      
    Real sign_e;
    Real e;
    Real a;
    Real angle;
    Real b;
    protected 
    Real min;
    Integer new_index;
    Real tmp;
    Real err_pos[2];
    constant Integer fw=0;
      
    public 
    Modelica.Blocks.Interfaces.RealOutput OUT[3] 
      annotation (extent=[80, -20; 100, 0]);
    Modelica.Blocks.Interfaces.RealInput Sensor[6] 
      annotation (extent=[-100, -80; -80, -60]);
    protected 
    Modelica.Blocks.Interfaces.IntegerSignal old_index 
      annotation (extent=[-20, 80; 0, 100]);
      
  algorithm 
    if initial() then
      old_index := 1;
      min := 1e10;
      new_index := 1;
      tmp := (table[1, 3] -Sensor[1])        ^2 + (table[1, 4] -Sensor[2])
           ^2;
    end if;
      
    if old_index + n >= size(table, 1) then
      terminate("Traiettoria finita!");
    end if;
      
    for i in old_index:(old_index + n) loop
      tmp := (table[i, 3] -Sensor[1])        ^2 + (table[i, 4] -Sensor[2])
           ^2;
      /*  
    if tmp<=0.001 then
      min:=tmp;
      new_index:=i;
      break;
    end if;
*/
      if tmp <= min or i == old_index or initial() then
        min := tmp;
        new_index := i;
      end if;
    end for;
      
    err_pos[1] :=Sensor[1]         - table[new_index, 3];
    err_pos[2] :=Sensor[2]         - table[new_index, 4];
      
    delta_s[1] := table[new_index, 3] - table[new_index - 1, 3];
    delta_s[2] := table[new_index, 4] - table[new_index - 1, 4];
      
    e := err_pos[1]*delta_s[2] - delta_s[1]*err_pos[2];
    sign_e := sign(e);
      
    OUT[1]        := table[new_index + fw, 5];
    OUT[2]        := -sqrt(min)*sign_e;
    a :=Sensor[5];
    //atan2(Sensor.signal[5], Sensor.signal[4]);
    angle := a*180/3.14;
    b := atan2(table[new_index + fw, 7], table[new_index + fw, 6]);
    OUT[3]        := a - b;
    old_index := new_index;
      
    annotation (Diagram);
  end Path_Table;
    
  model Gain_Steer_Control 
      
    parameter Real k1[:]={200} "Roll Angular position Forward Coefficient";
    parameter Real k2[:]={6.3} "Roll Angular Speed Forward Coefficient";
    parameter Real k3[:]={0.5} "Roll Angular Acceleration Forward Coefficient";
    parameter Real k4[:]={1} "Lenght Error Coefficient";
    parameter Real k5[:]={1} "Angle Speed Path Error Coeffiecient";
    Real k_V_R(start=0);
      
    Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
      annotation (extent=[88, -64; 100, -50], rotation=270);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
      annotation (extent=[80, -100; 100, -80]);
    Modelica.Blocks.Math.Atan Atan1 annotation (extent=[18, 72; 30, 84]);
    Modelica.Blocks.Math.Product Product1 annotation (extent=[-44, 64; -32, 76]);
    Modelica.Blocks.Math.Product Product2 annotation (extent=[-20, 64; -8, 76]);
    Modelica.Blocks.Math.Add Add1[+1](
      each k1=
         -1,
      each k2=
         +1) annotation (extent=[48, 68; 56, 80]);
    Modelica.Blocks.Math.Gain Gain2(k=1/9.8066) 
      annotation (extent=[-2, 68; 10, 80]);
    Modelica.Blocks.Math.Gain tmp(k=-1) 
      annotation (extent=[88, -12; 98, -4], rotation=270);
    Modelica.Blocks.Interfaces.RealInput Sensor[6] 
      annotation (extent=[-100, 50; -80, 70]);
    Modelica.Blocks.Continuous.Derivative Roll_Speed(T=0.01, k=1) 
      annotation (extent=[18, 48; 28, 58]);
    Modelica.Blocks.Continuous.Derivative Derivative2(T=0.01) 
      annotation (extent=[-6, 32; 4, 42]);
    Modelica.Blocks.Continuous.Derivative Roll_Acceleration(T=0.01, k=1) 
      annotation (extent=[-20, 32; -10, 42]);
    Modelica.Blocks.Interfaces.RealInput Signals[3] 
      annotation (extent=[-100, -20; -80, 0]);
    Modelica.Blocks.Routing.ExtractSignal VX(
      nout=1,
      extract={4},
      nin=6) annotation (extent=[-76, 66; -60, 78]);
    Modelica.Blocks.Routing.ExtractSignal ROLL(
      nout=1,
      nin=6,
      extract={6}) annotation (extent=[-76, 42; -60, 54]);
    Modelica.Blocks.Routing.DeMultiplex3 DeMultiplex3_1 
      annotation (extent=[-76, -18; -56, -2]);
    Modelica.Blocks.Math.Gain Curvature_sign(k=-1) 
      annotation (extent=[-48, 52; -32, 60]);
    Modelica.Blocks.Math.Sum Sum1(nin=5) 
      annotation (extent=[86, 0; 100, 10], rotation=270);
    Modelica.Blocks.Routing.Multiplex5 Multiplex5_1 
      annotation (extent=[72, 14; 88, 32]);
    Modelica.Blocks.Math.Gain K1(k=k1) 
      annotation (extent=[76, 68; 88, 80], rotation=0);
    protected 
    Modelica.Blocks.Interfaces.RealOutput outPort1 
      annotation (extent=[-33, 47; -31, 49]);
    public 
    Modelica.Blocks.Math.Gain K2(k=k2) 
      annotation (extent=[48, 48; 60, 60], rotation=0);
    Modelica.Blocks.Math.Gain K3(k=k3) 
      annotation (extent=[48, 22; 60, 34], rotation=0);
    Modelica.Blocks.Math.Gain K4(k=k4) 
      annotation (extent=[-42, -10; -30, 2],rotation=0);
    Modelica.Blocks.Math.Gain K5(k=k5) 
      annotation (extent=[-42, -32; -30, -20], rotation=0);
    Modelica.Blocks.Nonlinear.Limiter Limiter1(uMax=1000) 
      annotation (extent=[88, -34; 100, -22], rotation=270);
    Modelica.Blocks.Math.Add3 Add3_1 
      annotation (extent=[-18, 6; -2, 18], rotation=90);
  equation 
    connect(Product2.y,Gain2.u)             annotation (points=[-7.4,70; -6,70;
            -6,74; -3.2,74],     style(color=3, rgbcolor={0,0,255}));
    connect(Gain2.y,Atan1.u)             annotation (points=[10.6, 74; 13.3, 74;
          13.3, 78; 16.8, 78], style(color=3, rgbcolor={0,0,255}));
    annotation (Diagram);
    connect(Atan1.y,Add1.u1[1])          annotation (points=[30.6, 78; 33.9, 78;
          33.9, 77.6; 47.2, 77.6], style(color=3, rgbcolor={0,0,255}));
    connect(Roll_Acceleration.y,Derivative2.u)             annotation (points=[
          -9.5, 37; -7, 37], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u1)          annotation (points=[-59.2, 72; -54,
          72; -54, 73.6; -45.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u2)          annotation (points=[-59.2, 72; -54,
          72; -54, 66.4; -45.2, 66.4], style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,ROLL.u)       annotation (points=[-90, 60; -82, 60; -82, 48;
          -77.6, 48],style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,VX.u)       annotation (points=[-90, 60; -82, 60; -82, 72; -77.6,
          72], style(color=3, rgbcolor={0,0,255}));
    connect(Product1.y,Product2.u1)             annotation (points=[-31.4, 70;
          -28, 70; -28, 73.6; -21.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(Signals,DeMultiplex3_1.u)       annotation (points=[-90, -10; -78,
          -10], style(color=3, rgbcolor={0,0,255}));
    k_V_R =Atan1.y;
    //VX.outPort.signal[1];//*(1/(sqrt(ROLL.outPort.signal[1]^2)+1));
    Multiplex5_1.inPort1.signal[1] =K1.y;
    //*VX.outPort.signal[1];
    Multiplex5_1.inPort2.signal[1] =K2.y;
    //K3.k=k3+sqrt(Curvature_sign.outPort.signal[1]^2-0.25);
    Multiplex5_1.inPort3.signal[1] =K3.y;
    Multiplex5_1.inPort4.signal[1] = 0;
    //K4.outPort.signal[1];//*(1/(k_V_R^0.2+1));
    Multiplex5_1.inPort5.signal[1] = 0;
    //K5.outPort.signal[1];//*k_V_R*(-Modelica.Math.atan(ROLL.outPort.signal[1]));
    connect(Add1.y[1],K1.u)          annotation (points=[56.4, 74; 74.8, 74],
        style(color=3, rgbcolor={0,0,255}));
    connect(Curvature_sign.y,Product2.u2)             annotation (points=[-31.2,
          56; -26, 56; -26, 66.4; -21.2, 66.4], style(color=3, rgbcolor={0,0,
            255}));
    connect(ROLL.y[1],    outPort1) annotation (points=[-59.2, 48; -32, 48],
        style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Add1.u2[1])    annotation (points=[-32, 48; 8, 48; 8, 64;
          30, 64; 30, 70.4; 47.2, 70.4], style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Roll_Speed.u)       annotation (points=[-32, 48; 8, 48; 8,
          53; 17, 53], style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Roll_Acceleration.u)       annotation (points=[-32, 48; -32,
          37; -21, 37],style(color=3, rgbcolor={0,0,255}));
    connect(Multiplex5_1.y,Sum1.u)             annotation (points=[88.8, 23; 93,
          23; 93, 11], style(color=3, rgbcolor={0,0,255}));
    connect(Sum1.y,tmp.u)             annotation (points=[93, -0.5; 93, -3.2],
        style(color=3, rgbcolor={0,0,255}));
    connect(Torque1.flange_b, flange_steer) annotation (points=[94, -64; 94, -90;
          90, -90],style(color=0, rgbcolor={0,0,0}));
    connect(Roll_Speed.y,K2.u)             annotation (points=[28.5, 53; 37.25,
          53; 37.25, 54; 46.8, 54], style(color=3, rgbcolor={0,0,255}));
    connect(DeMultiplex3_1.y2[1],K4.u)          annotation (points=[-55, -10; -48,
          -10; -48, -4; -43.2, -4], style(color=3, rgbcolor={0,0,255}));
    connect(DeMultiplex3_1.y3[1],K5.u)          annotation (points=[-55,-15.6;
          -47.8,-15.6; -47.8,-26; -43.2,-26],    style(color=3, rgbcolor={0,0,
            255}));
    connect(Derivative2.y,K3.u)             annotation (points=[4.5, 37; 36, 37;
          36, 28; 46.8, 28], style(color=3, rgbcolor={0,0,255}));
    connect(Limiter1.y,Torque1.tau)           annotation (points=[94, -34.6; 94,
          -48.6], style(color=3, rgbcolor={0,0,255}));
    connect(tmp.y,Limiter1.u)             annotation (points=[93, -12.4; 93, -16.2;
          94, -16.2; 94, -20.8], style(color=3, rgbcolor={0,0,255}));
    connect(Curvature_sign.u,Add3_1.y)             annotation (points=[-49.6,
          56; -54, 56; -54, 24; -10, 24; -10, 18.6], style(color=3, rgbcolor={0,
            0,255}));
    connect(DeMultiplex3_1.y1[1],Add3_1.u1)          annotation (points=[-55,-4.4;
            -52,-4.4; -52,8; -24,8; -24,4.8; -16.4,4.8],          style(color=3,
          rgbcolor={0,0,255}));
    connect(K4.y,Add3_1.u2)             annotation (points=[-29.4,-4; -10,-4; -10,
            4.8],   style(color=3, rgbcolor={0,0,255}));
    connect(K5.y,Add3_1.u3)             annotation (points=[-29.4,-26; -3.6,-26;
            -3.6,4.8],     style(color=3, rgbcolor={0,0,255}));
  end Gain_Steer_Control;
    
  model Noise_Filter 
    Modelica.Blocks.Continuous.FirstOrder FirstOrder1(T=T, k={1,
            1,1}) 
      annotation (extent=[-20, 0; 0, 20]);
    Modelica.Blocks.Interfaces.RealInput InPort1[3] 
      annotation (extent=[-100, 0; -80, 20]);
    annotation (Diagram);
    Modelica.Blocks.Interfaces.RealOutput OutPort1[3] 
      annotation (extent=[80, 0; 100, 20]);
    parameter Modelica.SIunits.Time T[:]={100,100,100} "Filtering parameter.";
  equation 
    connect(InPort1[1],FirstOrder1.u)    annotation (points=[-90, 10; -22, 10],
        style(color=3, rgbcolor={0,0,255}));
    connect(FirstOrder1.y,       OutPort1[1]) 
      annotation (points=[1, 10; 90, 10], style(color=3, rgbcolor={0,0,255}));
  end Noise_Filter;
    
  model Steer_Control_3 
      
    parameter Real k1[:]={10} "Roll Angular Speed Forward Coefficient";
    parameter Real k2[:]={6.3} "Roll Angular Acceleration Forward Coefficient";
    parameter Real k3[:]={-0.1} "Lenght Error Coefficient";
    parameter Real k4[:]={-0.01} "Angle Error Coefficient";
      
    Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
      annotation (extent=[88, -64; 100, -50], rotation=270);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
      annotation (extent=[80, -100; 100, -80]);
    Modelica.Blocks.Math.Atan Atan1 annotation (extent=[18, 72; 30, 84]);
    Modelica.Blocks.Math.Product Product1 annotation (extent=[-44, 64; -32, 76]);
    Modelica.Blocks.Math.Product Product2 annotation (extent=[-20, 64; -8, 76]);
    Modelica.Blocks.Math.Add Add1[+1](
      each k1=
         +1,
      each k2=
         -1) annotation (extent=[34, 68; 42, 80]);
    Modelica.Blocks.Math.Gain Gain2(k=1/9.8066) 
      annotation (extent=[-2, 68; 10, 80]);
    Modelica.Blocks.Interfaces.RealInput Sensor[6] 
      annotation (extent=[-100, 50; -80, 70]);
    Modelica.Blocks.Continuous.Derivative Roll_Speed(T=0.01, k=1) 
      annotation (extent=[14, 48; 24, 58]);
    Modelica.Blocks.Continuous.Derivative Derivative2(T=0.01) 
      annotation (extent=[-6, 32; 4, 42]);
    Modelica.Blocks.Continuous.Derivative Roll_Acceleration(T=0.01, k=1) 
      annotation (extent=[-20, 32; -10, 42]);
    Modelica.Blocks.Interfaces.RealInput Signals[3] 
      annotation (extent=[-100, -20; -80, 0]);
    Modelica.Blocks.Routing.ExtractSignal VX(
      nout=1,
      extract={4},
      nin=6) annotation (extent=[-76, 66; -60, 78]);
    Modelica.Blocks.Routing.ExtractSignal ROLL(
      nout=1,
      nin=6,
      extract={6}) annotation (extent=[-76, 42; -60, 54]);
    Modelica.Blocks.Routing.DeMultiplex3 DeMultiplex3_1 
      annotation (extent=[-76, -18; -56, -2]);
    Modelica.Blocks.Math.Gain Curvature_sign(k=-1) 
      annotation (extent=[-48, 52; -32, 60]);
    Modelica.Blocks.Math.Gain K1(k=k1) 
      annotation (extent=[34, 50; 42, 56], rotation=0);
    protected 
    Modelica.Blocks.Interfaces.RealOutput outPort1 
      annotation (extent=[-33, 47; -31, 49]);
    public 
    Modelica.Blocks.Math.Gain K2(k=k2) 
      annotation (extent=[16, 34; 26, 40], rotation=0);
    Modelica.Blocks.Math.Gain K3(k=k3) 
      annotation (extent=[-42, -6; -30, 6], rotation=0);
    Modelica.Blocks.Math.Gain K4(k=k4) 
      annotation (extent=[-42, -28; -30, -16], rotation=0);
    Modelica.Blocks.Continuous.PI PI1(T=PI1_T, k=PI1_k) 
      annotation (extent=[78, 70; 90, 82]);
    Modelica.Blocks.Continuous.PI PI2(T=PI2_T, k=PI2_k) 
      annotation (extent=[132, 66; 144, 78]);
    Modelica.Blocks.Math.Add Add2[+1](
      each k1=
         +1,
      each k2=
         -1) annotation (extent=[118, 66; 126, 78]);
    Modelica.Blocks.Math.Add3 Add3_1 annotation (extent=[64, 68; 74, 84]);
    parameter Real PI1_k[:]={10};
    parameter Modelica.SIunits.Time PI1_T[:]={1e10};
    parameter Real PI2_k[:]={-0.1};
    parameter Modelica.SIunits.Time PI2_T[:]={0.1};
    Modelica.Blocks.Math.Add3 Add3_2 annotation (extent=[-10, -10; 0, 6]);
  equation 
    connect(Product2.y,Gain2.u)             annotation (points=[-7.4,70; -6,70;
          -6,74; -3.2,74],       style(color=3, rgbcolor={0,0,255}));
    connect(Gain2.y,Atan1.u)             annotation (points=[10.6, 74; 13.3, 74;
          13.3, 78; 16.8, 78], style(color=3, rgbcolor={0,0,255}));
    annotation (Diagram);
    connect(Atan1.y,Add1.u1[1])          annotation (points=[30.6, 78; 33.9, 78;
          33.9, 77.6; 33.2, 77.6], style(color=3, rgbcolor={0,0,255}));
    connect(Roll_Acceleration.y,Derivative2.u)             annotation (points=[
          -9.5, 37; -7, 37], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u1)          annotation (points=[-59.2, 72; -54,
          72; -54, 73.6; -45.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u2)          annotation (points=[-59.2, 72; -54,
          72; -54, 66.4; -45.2, 66.4], style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,ROLL.u)       annotation (points=[-90, 60; -82, 60; -82, 48;
          -77.6, 48],style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,VX.u)       annotation (points=[-90, 60; -82, 60; -82, 72; -77.6,
          72], style(color=3, rgbcolor={0,0,255}));
    connect(Product1.y,Product2.u1)             annotation (points=[-31.4, 70;
          -28, 70; -28, 73.6; -21.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(Signals,DeMultiplex3_1.u)       annotation (points=[-90, -10; -78,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(Curvature_sign.y,Product2.u2)             annotation (points=[-31.2,
          56; -26, 56; -26, 66.4; -21.2, 66.4], style(color=3, rgbcolor={0,0,
            255}));
    connect(ROLL.y[1],    outPort1) annotation (points=[-59.2, 48; -32, 48],
        style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Add1.u2[1])    annotation (points=[-32, 48; 8, 48; 8, 64;
          30, 64; 30, 70.4; 33.2, 70.4], style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Roll_Speed.u)       annotation (points=[-32, 48; 8, 48; 8,
          53; 13, 53], style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Roll_Acceleration.u)       annotation (points=[-32, 48; -32,
          37; -21, 37],style(color=3, rgbcolor={0,0,255}));
    connect(Torque1.flange_b, flange_steer) annotation (points=[94, -64; 94, -90;
          90, -90],style(color=0, rgbcolor={0,0,0}));
    connect(DeMultiplex3_1.y2[1],K3.u)          annotation (points=[-55, -10; -50,
          -10; -50, 0; -43.2, 0], style(color=3, rgbcolor={0,0,255}));
    connect(DeMultiplex3_1.y3[1],K4.u)          annotation (points=[-55,-15.6;
          -49.8,-15.6; -49.8,-22; -43.2,-22],    style(color=3, rgbcolor={0,0,
            255}));
    connect(Add3_1.y,PI1.u)             annotation (points=[74.5, 76; 76.8, 76],
        style(color=3, rgbcolor={0,0,255}));
    connect(Roll_Speed.y,K1.u)             annotation (points=[24.5, 53; 33.2,
          53], style(color=3, rgbcolor={0,0,255}));
    connect(Add1.y[1],Add3_1.u1)          annotation (points=[42.4, 74; 44, 74;
          44, 82.4; 63, 82.4], style(color=3, rgbcolor={0,0,255}));
    connect(K1.y,Add3_1.u2)             annotation (points=[42.4, 53; 50, 53;
          50, 76; 63, 76], style(color=3, rgbcolor={0,0,255}));
    connect(Derivative2.y,K2.u)             annotation (points=[4.5, 37; 10.25,
          37; 10.25, 37; 15, 37], style(color=3, rgbcolor={0,0,255}));
    connect(Add2.y[1],PI2.u)          annotation (points=[126.4, 72; 130.8, 72],
        style(color=3, rgbcolor={0,0,255}));
    connect(PI2.y,Torque1.tau)           annotation (points=[144.6, 72; 146, 72;
          146, -48.6; 94, -48.6], style(color=3, rgbcolor={0,0,255}));
    connect(Roll_Speed.y,Add2.u2[1])          annotation (points=[24.5, 53;
          24.5, 46; 112, 46; 112, 68.4; 117.2, 68.4], style(color=3, rgbcolor={
            0,0,255}));
    connect(PI1.y,Add2.u1[1])          annotation (points=[90.6, 76; 103.9, 76;
          103.9, 75.6; 117.2, 75.6], style(color=3, rgbcolor={0,0,255}));
    connect(K2.y,Add3_1.u3)             annotation (points=[26.5, 37; 58, 37;
          58, 69.6; 63, 69.6], style(color=3, rgbcolor={0,0,255}));
    connect(DeMultiplex3_1.y1[1],Add3_2.u1)          annotation (points=[-55,-4.4;
          -55,10; -16,10; -16,4.4; -11,4.4],     style(color=3, rgbcolor={0,0,
            255}));
    connect(K3.y,Add3_2.u2)             annotation (points=[-29.4, 0; -20, 0; -20,
          -2; -11, -2],style(color=3, rgbcolor={0,0,255}));
    connect(K4.y,Add3_2.u3)             annotation (points=[-29.4, -22; -26, -22;
          -26, -16; -24, -16; -24, -8.4; -11, -8.4], style(color=3, rgbcolor={0,
            0,255}));
    connect(Add3_2.y,Curvature_sign.u)             annotation (points=[0.5, -2;
          12, -2; 12, 20; -54, 20; -54, 56; -49.6, 56], style(color=3, rgbcolor=
           {0,0,255}));
  end Steer_Control_3;
    
  model Steer_Control_PID 
      
    parameter Real k3[:]={0.5} "Lenght Error Coefficient";
    parameter Real k4[:]={1} "Angle Error Coefficient";
      
    Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
      annotation (extent=[88, -64; 100, -50], rotation=270);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
      annotation (extent=[80, -100; 100, -80]);
    Modelica.Blocks.Math.Atan Atan1 annotation (extent=[18, 72; 30, 84]);
    Modelica.Blocks.Math.Product Product1 annotation (extent=[-44, 64; -32, 76]);
    Modelica.Blocks.Math.Product Product2 annotation (extent=[-20, 64; -8, 76]);
    Modelica.Blocks.Math.Add Add1[+1](
      each k1=
         +1,
      each k2=
         -1) annotation (extent=[34, 68; 42, 80]);
    Modelica.Blocks.Math.Gain Gain2(k=1/9.8066) 
      annotation (extent=[-2, 68; 10, 80]);
    Modelica.Blocks.Interfaces.RealInput Sensor[6] 
      annotation (extent=[-100, 50; -80, 70]);
    Modelica.Blocks.Interfaces.RealInput Signals[3] 
      annotation (extent=[-100, -20; -80, 0]);
    Modelica.Blocks.Routing.ExtractSignal VX(
      nout=1,
      extract={4},
      nin=6) annotation (extent=[-76, 66; -60, 78]);
    Modelica.Blocks.Routing.ExtractSignal ROLL(
      nout=1,
      nin=6,
      extract={6}) annotation (extent=[-76, 42; -60, 54]);
    Modelica.Blocks.Routing.DeMultiplex3 DeMultiplex3_1 
      annotation (extent=[-76, -18; -56, -2]);
    Modelica.Blocks.Math.Gain K3(k=k3) 
      annotation (extent=[-42, -16; -30, -4], rotation=0);
    Modelica.Blocks.Math.Gain K4(k=k4) 
      annotation (extent=[-42, -36; -30, -24], rotation=0);
    Modelica.Blocks.Math.Add3 Add3_2 
      annotation (extent=[-30, 22; -20, 38], rotation=90);
    Modelica.Blocks.Continuous.PID PID1(
      k=k,
      Ti=Ti,
      Td=Td,
      Nd=Nd) annotation (extent=[50, 68; 64, 80]);
    parameter Real k=1 "PID Gain";
    parameter Modelica.SIunits.Time Ti=0.5 "PID Time Cnstant of Integrator";
    parameter Modelica.SIunits.Time Td=0.1 
        "PID Time Constant of Derivative Block";
    parameter Real Nd=10 "PID Parameter for ideal derivative block";
  equation 
    connect(Product2.y,Gain2.u)             annotation (points=[-7.4,70; -6,70;
            -6,74; -3.2,74],     style(color=3, rgbcolor={0,0,255}));
    connect(Gain2.y,Atan1.u)             annotation (points=[10.6, 74; 13.3, 74;
          13.3, 78; 16.8, 78], style(color=3, rgbcolor={0,0,255}));
    annotation (Diagram);
    connect(Atan1.y,Add1.u1[1])          annotation (points=[30.6, 78; 33.9, 78;
          33.9, 77.6; 33.2, 77.6], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u1)          annotation (points=[-59.2, 72; -54,
          72; -54, 73.6; -45.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u2)          annotation (points=[-59.2, 72; -54,
          72; -54, 66.4; -45.2, 66.4], style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,ROLL.u)       annotation (points=[-90, 60; -82, 60; -82, 48;
          -77.6, 48],style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,VX.u)       annotation (points=[-90, 60; -82, 60; -82, 72; -77.6,
          72], style(color=3, rgbcolor={0,0,255}));
    connect(Product1.y,Product2.u1)             annotation (points=[-31.4, 70;
          -28, 70; -28, 73.6; -21.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(Signals,DeMultiplex3_1.u)       annotation (points=[-90, -10; -78,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(Torque1.flange_b, flange_steer) annotation (points=[94, -64; 94, -90;
          90, -90],style(color=0, rgbcolor={0,0,0}));
    connect(DeMultiplex3_1.y2[1],K3.u)          annotation (points=[-55, -10; -43.2,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(DeMultiplex3_1.y3[1],K4.u)          annotation (points=[-55, -15.6;
          -49.8, -15.6; -49.8, -30; -43.2, -30], style(color=3, rgbcolor={0,0,
            255}));
    connect(Product2.u2,Add3_2.y)             annotation (points=[-21.2, 66.4;
          -25, 66.4; -25, 38.8], style(color=3, rgbcolor={0,0,255}));
    connect(K3.y,Add3_2.u2)             annotation (points=[-29.4, -10; -25, -10;
          -25, 20.4],style(color=3, rgbcolor={0,0,255}));
    connect(K4.y,Add3_2.u3)             annotation (points=[-29.4, -30; -21, -30;
          -21, 20.4],style(color=3, rgbcolor={0,0,255}));
    connect(DeMultiplex3_1.y1[1],Add3_2.u1)          annotation (points=[-55, -4.4;
          -46, -4.4; -46, 4; -29, 4; -29, 20.4], style(color=3, rgbcolor={0,0,
            255}));
    connect(ROLL.y,Add1.u2)             annotation (points=[-59.2, 48; 22, 48;
          22, 70.4; 33.2, 70.4], style(color=3, rgbcolor={0,0,255}));
    connect(Add1.y[1],PID1.u)          annotation (points=[42.4, 74; 48.6, 74],
        style(color=3, rgbcolor={0,0,255}));
    connect(PID1.y,Torque1.tau)           annotation (points=[64.7, 74; 94, 74;
          94, -48.6], style(color=3, rgbcolor={0,0,255}));
  end Steer_Control_PID;
    
  model Path_Table_Opt "Table look-up in one dimension (matrix/file)" 
      import Modelica.Math.*;
    parameter Integer n=3 "number of iterations";
    Real delta_s[2];
      
    Real sign_e;
    Real e;
    Real a;
    Real angle;
    Real b;
    protected 
    Real min;
    Integer new_index;
    Real tmp;
    Real err_pos[2];
    constant Integer fw=0;
    Real tmp_table;
    Real tmp_table2;
    Integer i;
    public 
    Modelica.Blocks.Interfaces.RealOutput OUT[3] 
      annotation (extent=[80, -20; 100, 0]);
    Modelica.Blocks.Interfaces.RealInput Sensor[6] 
      annotation (extent=[-100, -80; -80, -60]);
    protected 
    Modelica.Blocks.Interfaces.IntegerSignal old_index 
      annotation (extent=[-20, 80; 0, 100]);
    public 
    Modelica.Blocks.Tables.CombiTable2D table(
      fileName=fileName,
      smoothness=smoothNess,
      table=Table,
      tableName=tableName,
      tableOnFile=(tableName) <> "NoName") 
                   annotation (extent=[-20, -20; 0, 0]);
    public 
    parameter String tableName="NoName" "tableName";
    parameter String fileName="NoName" "fileName";
    parameter Integer smoothNess=0 "smoothNess";
    parameter Real Table[:, :]=[0, 0; 1, 1] "table";
      
  algorithm 
    if initial() then
      old_index := 1;
      min := 1e10;
      new_index := 1;
      table.u1                := 1;
      table.u2                := 2;
      tmp_table :=table.y;
      table.u1                := 1;
      table.u2                := 3;
      tmp_table2 :=table.y;
      tmp := (tmp_table -Sensor[1])        ^2 + (tmp_table2 -Sensor[2])
        ^2;
    end if;
      
    if old_index + n >= size(table.table, 1) then
      terminate("Traiettoria finita!");
    end if;
      
    //for i in old_index:(old_index + n) loop
    i := old_index;
    while i < old_index + n loop
      table.u1                := i;
      table.u2                := 2;
      tmp_table :=table.y;
      table.u1                := i;
      table.u2                := 3;
      tmp_table2 :=table.y;
      tmp := (tmp_table -Sensor[1])        ^2 + (tmp_table2 -Sensor[2])
        ^2;
        
      if tmp <= min or i == old_index or initial() then
        min := tmp;
        new_index := i;
      end if;
      i := i + 1;
    end while;
    //end for;
      
    table.u1                := new_index;
    table.u2                := 2;
    tmp_table :=table.y;
    err_pos[1] :=Sensor[1]         - tmp_table;
      
    table.u1                := new_index;
    table.u2                := 3;
    tmp_table :=table.y;
    err_pos[2] :=Sensor[2]         - tmp_table;
      
    table.u1                := new_index;
    table.u2                := 2;
    tmp_table :=table.y;
    table.u1                := new_index - 1;
    table.u2                := 2;
    tmp_table2 :=table.y;
    delta_s[1] := tmp_table - tmp_table2;
      
    table.u1                := new_index;
    table.u2                := 3;
    tmp_table :=table.y;
    table.u1                := new_index - 1;
    table.u2                := 3;
    tmp_table2 :=table.y;
    delta_s[2] := tmp_table - tmp_table2;
      
    e := err_pos[1]*delta_s[2] - delta_s[1]*err_pos[2];
    sign_e := sign(e);
      
    table.u1                := new_index + fw;
    table.u2                := 4;
    tmp_table :=table.y;
    OUT[1]        := tmp_table;
      
    OUT[2]        := -sqrt(min)*sign_e;
      
    a :=Sensor[5];
    angle := a*180/3.14;
      
    table.u1                := new_index + fw;
    table.u2                := 6;
    tmp_table :=table.y;
    table.u1                := new_index + fw;
    table.u2                := 5;
    tmp_table2 :=table.y;
    b := atan2(tmp_table, tmp_table2);
      
    OUT[3]        := a - b;
    old_index := new_index;
      
    annotation (Diagram);
  end Path_Table_Opt;
    
  model Path_Table_Opt_2 "Table look-up in one dimension (matrix/file)" 
      import Modelica.Math.*;
      import Modelica.Mechanics.MultiBody.Frames.*;
    parameter Integer n=3 "number of iterations";
      
    protected 
    Real sign_e;
    Real e;
    Real a;
    Real angle;
    Real b;
    Real dist;
    Real err_pos[2];
    Real err_pos_t;
    Real delta_s[2];
    Real p[2];
    Real q1;
    Real q2;
    Real m2;
    Real to_pm[2];
    Real to_pt[2];
    Real sign_t;
    Real t[2];
    Real m[2];
    public 
    Modelica.Blocks.Interfaces.RealOutput toSteerControl[3] 
        "C, position error, angle error" 
                                       annotation (extent=[80, -20; 100, 0]);
    Modelica.Blocks.Interfaces.RealInput Sensor[6] 
      annotation (extent=[-100, -80; -80, -60]);
    public 
    parameter String tableName="NoName" "tableName";
    parameter String fileName="NoName" "fileName";
    parameter Integer smoothNess=0 "smoothNess";
    parameter Real Table[:, :]=[0, 0; 1, 1] "table";
    parameter Real K_Torque=0;
      
    Modelica.Blocks.Sources.CombiTimeTable Time_Table(
      fileName=fileName,
      table=Table,
      columns=integer(({2,3,4,5,6,7,8})),
      tableName=tableName,
      tableOnFile=(tableName) <> "NoName") 
                         annotation (extent=[-100, 80; -80, 100]);
    public 
    Modelica.Blocks.Interfaces.RealOutput toTorqueControl "Speed Set Point" 
      annotation (extent=[80, -100; 100, -80]);
  equation 
    dist = sqrt((Time_Table.y[1] -Sensor[1])        ^2 + (Time_Table.y[2] -Sensor[2])
                       ^2);
      
    err_pos[1] =Sensor[1]         - Time_Table.y[1];
    err_pos[2] =Sensor[2]         - Time_Table.y[2];
      
    delta_s[1] = Time_Table.y[5];
    delta_s[2] = Time_Table.y[6];
      
    e = err_pos[1]*delta_s[2] - delta_s[1]*err_pos[2];
    sign_e = sign(e);
      
    toSteerControl[1]        = -Time_Table.y[4];
      
    toSteerControl[2]        = -dist*sign_e;
      
    a =Sensor[5];
    angle = a*180/3.14;
      
    b = atan2(Time_Table.y[6], Time_Table.y[5]);
      
    toSteerControl[3]        = a - b;
      
    //Calcolo del punto di inersezione tra retta su cui giace vett.traiettoria e retta proiezione punto dove si trova moto su retta traiettoria
    t = {Time_Table.y[5],Time_Table.y[6]};
    // punto traiettoria
    m = {Sensor[1],Sensor[2]};
    // punto moto
      
    m2 = (t[2]/t[1]) + 1e-10;
    q2 = Time_Table.y[2] - m2*Time_Table.y[3];
    q1 = m[2] + (1/m2)*m[1];
    p[2] = m2*p[1] + q2;
    p[2] = -1/m2*p[1] + (m[2] + 1/m2*m[1]);
      
    to_pm = {m[1],m[2]} - {p[1],p[2]};
    to_pt = {Time_Table.y[2],Time_Table.y[3]} - {p[1],p[2]};
      
    sign_t = sign(to_pt[1]*to_pm[2] - to_pm[1]*to_pt[2]);
      
    err_pos_t = length(to_pt)*sign_t;
      
    toTorqueControl           = Time_Table.y[7] + K_Torque*err_pos_t;
      
    annotation (Diagram);
  end Path_Table_Opt_2;
    
  model Steer_Control_Mare 
      
    parameter Real k3[:]={0.5} "Lenght Error Coefficient";
    parameter Real k4[:]={1} "Angle Error Coefficient";
    Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
      annotation (extent=[88, -64; 100, -50], rotation=270);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
      annotation (extent=[80, -100; 100, -80]);
    Modelica.Blocks.Math.Atan Atan1 annotation (extent=[18, 72; 30, 84]);
    Modelica.Blocks.Math.Product Product1 annotation (extent=[-44, 64; -32, 76]);
    Modelica.Blocks.Math.Product Product2 annotation (extent=[-20, 64; -8, 76]);
    Modelica.Blocks.Math.Add Add1[+1](
      each k1=
         +1,
      each k2=
         -1) annotation (extent=[34, 68; 42, 80]);
    Modelica.Blocks.Math.Gain Gain2(k=1/9.8066) 
      annotation (extent=[-2, 68; 10, 80]);
    Modelica.Blocks.Interfaces.RealInput Sensor[6] 
      annotation (extent=[-100, 50; -80, 70]);
    Modelica.Blocks.Interfaces.RealInput Signals[2] 
      annotation (extent=[-100, -20; -80, 0]);
    Modelica.Blocks.Routing.ExtractSignal VX(
      nout=1,
      extract={4},
      nin=6) annotation (extent=[-76, 66; -60, 78]);
    Modelica.Blocks.Routing.ExtractSignal ROLL(
      nout=1,
      nin=6,
      extract={6}) annotation (extent=[-76, 42; -60, 54]);
    Modelica.Blocks.Math.Gain K3(k=k3) 
      annotation (extent=[-28, 16; -16, 28],rotation=0);
    Modelica.Blocks.Routing.ExtractSignal teta(
      nout=1,
      nin=6,
      extract={5}) annotation (extent=[-76, 18; -60, 30]);
    Modelica.Blocks.Routing.DeMultiplex2 DeMultiplex2_1 
      annotation (extent=[-70, -22; -50, -2]);
    Modelica.Blocks.Math.Add Add2(k2=-1) annotation (extent=[-50, 16; -36, 26]);
    Modelica.Blocks.Math.Add Add3(k2=+1) 
      annotation (extent=[-6, 28; 8, 38], rotation=90);
    Modelica.Blocks.Math.Gain K1(k=k3) 
      annotation (extent=[50, 68; 62, 80], rotation=0);
  equation 
    connect(Product2.y,Gain2.u)             annotation (points=[-7.4,70; -6,70;
            -6,74; -3.2,74],     style(color=3, rgbcolor={0,0,255}));
    connect(Gain2.y,Atan1.u)             annotation (points=[10.6, 74; 13.3, 74;
          13.3, 78; 16.8, 78], style(color=3, rgbcolor={0,0,255}));
    annotation (Diagram);
    connect(Atan1.y,Add1.u1[1])          annotation (points=[30.6, 78; 33.9, 78;
          33.9, 77.6; 33.2, 77.6], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u1)          annotation (points=[-59.2, 72; -54,
          72; -54, 73.6; -45.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u2)          annotation (points=[-59.2, 72; -54,
          72; -54, 66.4; -45.2, 66.4], style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,ROLL.u)       annotation (points=[-90, 60; -82, 60; -82, 48;
          -77.6, 48],style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,VX.u)       annotation (points=[-90, 60; -82, 60; -82, 72; -77.6,
          72], style(color=3, rgbcolor={0,0,255}));
    connect(Product1.y,Product2.u1)             annotation (points=[-31.4, 70;
          -28, 70; -28, 73.6; -21.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(Torque1.flange_b, flange_steer) annotation (points=[94, -64; 94, -90;
          90, -90],style(color=0, rgbcolor={0,0,0}));
    connect(ROLL.y,Add1.u2)             annotation (points=[-59.2, 48; 22, 48;
          22, 70.4; 33.2, 70.4], style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,teta.u)       annotation (points=[-90, 60; -86, 60; -86, 24;
          -77.6, 24],style(color=3, rgbcolor={0,0,255}));
    connect(Signals,DeMultiplex2_1.u)       annotation (points=[-90, -10; -80,
          -10; -80, -12; -72, -12], style(color=3, rgbcolor={0,0,255}));
    connect(teta.y[1],Add2.u1)          annotation (points=[-59.2, 24; -51.4,
          24], style(color=3, rgbcolor={0,0,255}));
    connect(Add3.y,Product2.u2)             annotation (points=[1,38.5; 1,54;
            -28,54; -28,66.4; -21.2,66.4],  style(color=3, rgbcolor={0,0,255}));
    connect(Add2.y,K3.u)             annotation (points=[-35.3, 21; -32.65, 21;
          -32.65, 22; -29.2, 22], style(color=3, rgbcolor={0,0,255}));
    connect(DeMultiplex2_1.y1[1],Add3.u2)          annotation (points=[-49, -6;
          -28, -6; -28, -8; 5.2, -8; 5.2, 27], style(color=3, rgbcolor={0,0,255}));
    connect(K3.y,Add3.u1)             annotation (points=[-15.4, 22; -10, 22; -10,
          27; -3.2, 27],style(color=3, rgbcolor={0,0,255}));
    connect(DeMultiplex2_1.y2[1],Add2.u2)          annotation (points=[-49, -18;
          -38, -18; -38, 10; -56, 10; -56, 18; -51.4, 18], style(color=3,
          rgbcolor={0,0,255}));
    connect(Add1.y[1],K1.u)          annotation (points=[42.4, 74; 48.8, 74],
        style(color=3, rgbcolor={0,0,255}));
  end Steer_Control_Mare;
    
  model Gain_Steer_Control_Matrix_R 
      
    parameter Real k1[:]={100} "Roll Angular position Forward Coefficient";
    parameter Real k2[:]={6.3} "Roll Angular Speed Forward Coefficient";
    parameter Real k3[:]={0.5} "Roll Angular Acceleration Forward Coefficient";
    parameter Real k4[:]={1} "Lenght Error Coefficient";
    parameter Real k5[:]={1} "Angle Speed Path Error Coeffiecient";
    Real k_V_R(start=0);
      
    Modelica.Mechanics.Rotational.Torque Torque1(tau(start=0)) 
      annotation (extent=[88, -64; 100, -50], rotation=270);
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_steer 
      annotation (extent=[80, -100; 100, -80]);
    Modelica.Blocks.Math.Atan Atan1 annotation (extent=[18, 72; 30, 84]);
    Modelica.Blocks.Math.Product Product1 annotation (extent=[-44, 64; -32, 76]);
    Modelica.Blocks.Math.Product Product2 annotation (extent=[-20, 64; -8, 76]);
    Modelica.Blocks.Math.Gain Gain2(k=1/9.8066) 
      annotation (extent=[-2, 68; 10, 80]);
    Modelica.Blocks.Math.Gain tmp(k=-1) 
      annotation (extent=[88, -14; 98, -6], rotation=270);
    Modelica.Blocks.Interfaces.RealInput Sensor[6] 
      annotation (extent=[-100, 50; -80, 70]);
    Modelica.Blocks.Continuous.Derivative Roll_Speed(T=0.01, k=1) 
      annotation (extent=[18, 48; 28, 58]);
    Modelica.Blocks.Continuous.Derivative Derivative2(T=0.01) 
      annotation (extent=[-6, 30; 4, 40]);
    Modelica.Blocks.Continuous.Derivative Roll_Acceleration(T=0.01, k=1) 
      annotation (extent=[-20, 32; -10, 42]);
    Modelica.Blocks.Interfaces.RealInput Signals[2] 
      annotation (extent=[-100, -20; -80, 0]);
    Modelica.Blocks.Routing.ExtractSignal VX(
      nout=1,
      extract={4},
      nin=6) annotation (extent=[-76, 66; -60, 78]);
    Modelica.Blocks.Routing.ExtractSignal ROLL(
      nout=1,
      nin=6,
      extract={6}) annotation (extent=[-76, 42; -60, 54]);
    Modelica.Blocks.Math.Sum Sum1(nin=5) 
      annotation (extent=[86, 0; 100, 10], rotation=270);
    Modelica.Blocks.Routing.Multiplex5 Multiplex5_1 
      annotation (extent=[72, 14; 88, 32]);
    Modelica.Blocks.Math.Gain K1(k=k1) 
      annotation (extent=[64, 68; 76, 80], rotation=0);
    protected 
    Modelica.Blocks.Interfaces.RealOutput outPort1 
      annotation (extent=[-33, 47; -31, 49]);
    public 
    Modelica.Blocks.Math.Gain K2(k=k2) 
      annotation (extent=[48, 48; 60, 60], rotation=0);
    Modelica.Blocks.Math.Gain K3(k=k3) 
      annotation (extent=[48, 22; 60, 34], rotation=0);
    Modelica.Blocks.Nonlinear.Limiter Limiter1(uMax=1000) 
      annotation (extent=[88, -34; 100, -22], rotation=270);
    Modelica.Blocks.Routing.DeMultiplex2 DeMultiplex2_1 
      annotation (extent=[-74, -20; -54, 0]);
    Modelica.Blocks.Math.Add3 Add3_1(k1=-1) annotation (extent=[42, 66; 54, 80]);
    public 
    Modelica.Blocks.Math.Gain K4(k=k4) 
      annotation (extent=[-46, 16; -34, 28],rotation=90);
    Modelica.Blocks.Sources.Constant Constant1(k=0) 
      annotation (extent=[-94, 86; -78, 96]);
    Modelica.Blocks.Continuous.TransferFunction TransferFunction1(b={-2,1}, a={
          1,2,1}) annotation (extent=[-44, -10; -28, 4]);
  equation 
    connect(Product2.y,Gain2.u)             annotation (points=[-7.4,70; -6,70;
            -6,74; -3.2,74],     style(color=3, rgbcolor={0,0,255}));
    connect(Gain2.y,Atan1.u)             annotation (points=[10.6, 74; 13.3, 74;
          13.3, 78; 16.8, 78], style(color=3, rgbcolor={0,0,255}));
    annotation (Diagram);
    connect(Roll_Acceleration.y,Derivative2.u)             annotation (points=[
          -9.5, 37; -8, 38; -8, 35; -7, 35], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u1)          annotation (points=[-59.2, 72; -54,
          72; -54, 73.6; -45.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    connect(VX.y[1],Product1.u2)          annotation (points=[-59.2, 72; -54,
          72; -54, 66.4; -45.2, 66.4], style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,ROLL.u)       annotation (points=[-90, 60; -82, 60; -82, 48;
          -77.6, 48],style(color=3, rgbcolor={0,0,255}));
    connect(Sensor,VX.u)       annotation (points=[-90, 60; -82, 60; -82, 72; -77.6,
          72], style(color=3, rgbcolor={0,0,255}));
    connect(Product1.y,Product2.u1)             annotation (points=[-31.4, 70;
          -28, 70; -28, 73.6; -21.2, 73.6], style(color=3, rgbcolor={0,0,255}));
    k_V_R =Atan1.y;
    //VX.outPort.signal[1];//*(1/(sqrt(ROLL.outPort.signal[1]^2)+1));
    Multiplex5_1.inPort1.signal[1] =K1.y;
    //*VX.outPort.signal[1];
    Multiplex5_1.inPort2.signal[1] =K2.y;
    //K3.k=k3+sqrt(Curvature_sign.outPort.signal[1]^2-0.25);
    Multiplex5_1.inPort3.signal[1] =K3.y;
    Multiplex5_1.inPort4.signal[1] =K4.y;
    //*(1/(k_V_R^0.2+1));
    Multiplex5_1.inPort5.signal[1] = 0;
    //K5.outPort.signal[1];//*k_V_R*(-Modelica.Math.atan(ROLL.outPort.signal[1]));
    connect(ROLL.y[1],    outPort1) annotation (points=[-59.2, 48; -32, 48],
        style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Roll_Speed.u)       annotation (points=[-32, 48; 8, 48; 8,
          53; 17, 53], style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Roll_Acceleration.u)       annotation (points=[-32, 48; -32,
          37; -21, 37],style(color=3, rgbcolor={0,0,255}));
    connect(Multiplex5_1.y,Sum1.u)             annotation (points=[88.8, 23; 93,
          23; 93, 11], style(color=3, rgbcolor={0,0,255}));
    connect(Sum1.y,tmp.u)             annotation (points=[93, -0.5; 93, -5.2],
        style(color=3, rgbcolor={0,0,255}));
    connect(Torque1.flange_b, flange_steer) annotation (points=[94, -64; 94, -90;
          90, -90],style(color=0, rgbcolor={0,0,0}));
    connect(Roll_Speed.y,K2.u)             annotation (points=[28.5, 53; 37.25,
          53; 37.25, 54; 46.8, 54], style(color=3, rgbcolor={0,0,255}));
    connect(Derivative2.y,K3.u)             annotation (points=[4.5, 35; 36, 35;
          36, 28; 46.8, 28], style(color=3, rgbcolor={0,0,255}));
    connect(Limiter1.y,Torque1.tau)           annotation (points=[94, -34.6; 94,
          -48.6], style(color=3, rgbcolor={0,0,255}));
    connect(tmp.y,Limiter1.u)             annotation (points=[93, -14.4; 93, -16.2;
          94, -16.2; 94, -20.8], style(color=3, rgbcolor={0,0,255}));
    connect(Signals,DeMultiplex2_1.u)       annotation (points=[-90, -10; -76,
          -10], style(color=3, rgbcolor={0,0,255}));
    connect(Atan1.y,Add3_1.u1)             annotation (points=[30.6, 78; 33.3,
          78; 33.3, 78.6; 40.8, 78.6], style(color=3, rgbcolor={0,0,255}));
    connect(Add3_1.y,K1.u)             annotation (points=[54.6, 73; 57.3, 73;
          57.3, 74; 62.8, 74], style(color=3, rgbcolor={0,0,255}));
    connect(outPort1,Add3_1.u2)       annotation (points=[-32, 48; -32, 60; 12,
          60; 12, 70; 34, 70; 34, 73; 40.8, 73], style(color=3, rgbcolor={0,0,
            255}));
    connect(Constant1.y,Product2.u2)             annotation (points=[-77.2, 91;
          -24, 91; -24, 66.4; -21.2, 66.4], style(color=3, rgbcolor={0,0,255}));
    connect(Product2.u2,Add3_1.u3)            annotation (points=[-21.2, 66.4;
          -21.2, 56; 6, 56; 6, 67.4; 40.8, 67.4], style(color=3, rgbcolor={0,0,
            255}));
    connect(DeMultiplex2_1.y1[1],TransferFunction1.u)          annotation (
        points=[-53,-4; -49.3,-4; -49.3,-3; -45.6,-3],     style(color=3,
          rgbcolor={0,0,255}));
    connect(TransferFunction1.y,K4.u)             annotation (points=[-27.2,-3;
            -16,-3; -16,14.8; -40,14.8],  style(color=3, rgbcolor={0,0,255}));
  end Gain_Steer_Control_Matrix_R;
    
  model KTM_950_Roll 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    constant Real pi= Modelica.Constants.pi;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=90,
          NumberOfIntervals=600,
          Tolerance=1e-006),
      experimentSetupOutput(
          states=false,
          derivatives=false,
          inputs=false,
          auxiliaries=false,
          equdistant=false,
          events=false),
      DymolaStoredErrors,
        Commands(file="Temp.mos" "Temp", file="Temp.mos" "Temp"));
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-100,-100; -80,-80]);
    inner Road road(
        d=0.01,
        a=55,
        b=50,
        choice=0) 
             annotation (extent=[46, -100; 100, -58]);
    public 
      inner parameter Supermotard_Dimension_MassPosition_Data 
        Dimension_MassPosition_data 
        annotation (extent=[60,80; 80,100]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model(                                                  Fz0=1144) 
        annotation (extent=[0,-56; 12,-46]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1(                                                  Fz0=1111) 
        annotation (extent=[62,-52; 74,-40]);
    protected 
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_120_70_ZR_17_Data 
        Pacejka_120_70_ZR_17_Data 
                                annotation (extent=[-80,80; -60,100]);
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_180_55_ZR_17_Data 
        Pacejka_180_55_ZR_17_Data 
                                annotation (extent=[-100,80; -80,100]);
    public 
    Motorcycle KTM_950(
        Rear_Wheel_data=Rear_Wheel_data,
        Dimension_MassPosition_data=Dimension_MassPosition_data,
        Rear_Pacejka_Friction_Data=Pacejka_180_55_ZR_17_Data,
        Front_Pacejka_Friction_Data=Pacejka_120_70_ZR_17_Data,
        Front_Suspension_data=Front_Suspension_data,
        Rear_Suspension_data=Rear_Suspension_data,
        xyz_init={0.40,0,0.3332 + 0.01},
        Front_Wheel_data=Front_Wheel_data) 
                          annotation (extent=[12,-30; 48,8]);
    public 
      Modelica.Blocks.Sources.Constant const(k=0) 
        annotation (extent=[8,-20; 16,-10]);
    Driver.Torque_Control torque_Control(
        Tstart=-1,
        Tfinish=0,
      T=0.2 + 0.07*0,
      k=45 + 29*0)                       annotation (extent=[-32,-28; -16,-12]);
    protected 
      MotorcycleDynamics.Chassis.Data.KTM_950_Chassis_Data Chassis_Data 
        annotation (extent=[60,60; 80,80]);
      
      Suspension.Front_Suspension.Data.KTM_950_Front_Suspension_data 
        Front_Suspension_data annotation (extent=[40,80; 60,100]);
      Suspension.Rear_Suspension.Data.KTM_950_Rear_Suspension_Data 
        Rear_Suspension_data(                                  s_unstretched=0.25,
          Spring=[-0.0746,-22640; -0.070,-15950; -0.069,-15470; -0.0675,-14655;
            -0.065,-13740; -0.060,-12300; -0.050,-9900; -0.0465,-9025; -0.040,-8050;
            -0.030,-6550; -0.020,-5050; -0.010,-3550; 0,2050; 0.010,3550; 0.020,
            5050; 0.030,6550; 0.040,8050; 0.0465,9025; 0.050,9900; 0.060,12300;
            0.065,13740; 0.0675,14655; 0.069,15470; 0.070,15950; 0.0746,22640]) 
                             annotation (extent=[80,80; 100,100]);
      inner 
        MotorcycleDynamics.Rear_Swinging_Arm.Data.KTM_950_Rear_Swingin_Arm_Data
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Wheel.Data.KTM_950_Rear_Wheel_Data Rear_Wheel_data 
        annotation (extent=[40,60; 60,80]);
      MotorcycleDynamics.Wheel.Data.KTM_950_Front_Wheel_Data Front_Wheel_data 
        annotation (extent=[80,60; 100,80]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed(
        tableOnFile=true,
        tableName="vx_tab",
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        startTime=10,
      fileName="C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
        annotation (extent=[-100,0; -80,20],   rotation=0);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Steer(
        tableOnFile=true,
        tableName="steer_tab",
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        startTime=10,
      fileName="C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
                     annotation (extent=[80,20; 100,40], rotation=180);
      Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,0; 0.3,0.5; 8,6.4;
            10,6.4; 10,0]) 
                    annotation (extent=[-100,-30; -80,-10]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Roll(
        tableOnFile=true,
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        tableName="roll_tab",
        startTime=10,
      fileName="C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
                     annotation (extent=[-60,32; -40,52],rotation=0);
      
    Driver.Roll_Driver_GR roll_Driver_GR(
        k3=0*0 + 1,
        k2=30*0 + 2,
        k1=20 + 70*0) 
            annotation (extent=[4,20; 24,40]);
      Modelica.Blocks.Math.Gain gain1(k=1.8 + 1.6*0) 
                                             annotation (extent=[-26,32; -6,52]);
      Modelica.Blocks.Math.Add add annotation (extent=[-62,-16; -42,4]);
      Modelica.Blocks.Interfaces.RealOutput Roll_SP[size(Roll.y, 1)] 
        annotation (extent=[-46,84; -26,104]);
      Modelica.Blocks.Interfaces.RealOutput Moto_Sensor[6] 
        annotation (extent=[-46,-104; -26,-84]);
      Modelica.Blocks.Interfaces.RealOutput Speed_SP[size(Speed.y, 1)] 
        annotation (extent=[-104,46; -84,66]);
      Modelica.Blocks.Interfaces.RealOutput Steer_SP[size(Steer.y, 1)] 
        annotation (extent=[86,42; 106,62]);
      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor 
        annotation (extent=[68,-4; 88,16]);
      Modelica.Blocks.Interfaces.RealOutput Steer_Sensor 
        annotation (extent=[100,-4; 120,16]);
  equation 
  torque_Control.Rear_Slip=KTM_950.Pin1.slip;
  gain1.u = if time< 17.114 then 0 else Roll.y[1];
      
      connect(KTM_950.Pin2, pacejka_Friction_Model1.Pin)  annotation (points=[68.16,
            -31.9; 68.16,-35.95; 68,-35.95; 68,-40.6],     style(color=3,
          rgbcolor={0,0,255}));
      connect(KTM_950.Pin1, pacejka_Friction_Model.Pin)  annotation (points=[6.6,
            -38.36; 6.6,-42.18; 6,-42.18; 6,-46.5],           style(color=3,
          rgbcolor={0,0,255}));
      connect(Aerodynamics1.frame_a, KTM_950.Pressure_center)  annotation (points=[-11,81;
            -11,49.5; 38.64,49.5; 38.64,1.92],          style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
      connect(const.y, KTM_950.Rear_Brake1)  annotation (points=[16.4,-15; 22,
            -15; 22,-21.26; 26.04,-21.26],
                                    style(color=74, rgbcolor={0,0,127}));
      connect(torque_Control.flange_rear_hub, KTM_950.Rear_Joint) annotation (
          points=[-16.8,-27.2; -5.4,-27.2; -5.4,-27.53; 7.5,-27.53], style(
            color=0, rgbcolor={0,0,0}));
      connect(torque_Control.frame_Seaddle, KTM_950.frame_Saddle1) annotation (
          points=[-16,-17.6; -10,-17.6; -10,-18; 0,-18; 0,0; 26.22,0; 26.22,
            -8.53],
          style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(torque_Control.y1, KTM_950.Front_Brake1) annotation (points=[-17.12,
            -12.8; -17.12,6.48; 49.8,6.48],        style(color=74, rgbcolor={0,
              0,127}));
    connect(roll_Driver_GR.flange_steering, KTM_950.Steering) annotation (points=[23,33;
            53.22,33; 53.22,6.67],        style(color=0, rgbcolor={0,0,0}));
    connect(roll_Driver_GR.frame_Seaddle, KTM_950.frame_Saddle1) annotation (
        points=[13,21; 13,12; 26.22,12; 26.22,-8.53], style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
    connect(roll_Driver_GR.Sensors, KTM_950.Sensor) annotation (points=[5,29;
            -12,29; -12,-33.61; -1.5,-33.61],style(color=74, rgbcolor={0,0,127}));
      connect(gain1.y, roll_Driver_GR.Roll_SP) annotation (points=[-5,42; -2,42; -2,36;
            5,36; 5,37], style(color=74, rgbcolor={0,0,127}));
      connect(add.y, torque_Control.SP_Speed) annotation (points=[-41,-6; -39.5,
            -6; -39.5,-12.8; -31.2,-12.8], style(color=74, rgbcolor={0,0,127}));
      connect(timeTable1.y, add.u2) annotation (points=[-79,-20; -74,-20; -74,
            -12; -64,-12], style(color=74, rgbcolor={0,0,127}));
      connect(add.u1, Speed.y[1]) annotation (points=[-64,0; -74,0; -74,10; -79,
            10], style(color=74, rgbcolor={0,0,127}));
      connect(Roll.y, Roll_SP) annotation (points=[-39,42; -38,42; -38,94; -36,
            94], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Sensor, Moto_Sensor) annotation (points=[-1.5,-33.61;
            -1.5,-63.805; -36,-63.805; -36,-94], style(color=74, rgbcolor={0,0,
              127}));
      connect(Speed.y, Speed_SP) annotation (points=[-79,10; -74,10; -74,56;
            -94,56], style(color=74, rgbcolor={0,0,127}));
      connect(Steer.y, Steer_SP) annotation (points=[79,30; 74,30; 74,52; 96,52],
          style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Steering, angleSensor.flange_a) annotation (points=[53.22,
            6.67; 60.61,6.67; 60.61,6; 68,6], style(color=0, rgbcolor={0,0,0}));
      connect(angleSensor.phi, Steer_Sensor) 
        annotation (points=[89,6; 110,6], style(color=74, rgbcolor={0,0,127}));
  end KTM_950_Roll;
    
  model KTM_950_Roll_II 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    constant Real pi= Modelica.Constants.pi;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=25,
          NumberOfIntervals=100,
          Tolerance=1e-006),
      experimentSetupOutput(equdistant=false, events=false),
      DymolaStoredErrors,
        Commands(file="Temp.mos" "Temp", file="Temp.mos" "Temp"));
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-100,-100; -80,-80]);
    inner Road road(
        d=0.01,
        a=55,
        b=50,
        choice=0) 
             annotation (extent=[46, -100; 100, -58]);
    public 
      inner parameter Supermotard_Dimension_MassPosition_Data 
        Dimension_MassPosition_data 
        annotation (extent=[60,80; 80,100]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model(                                                  Fz0=1144) 
        annotation (extent=[0,-56; 12,-46]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1(                                                  Fz0=1111) 
        annotation (extent=[62,-52; 74,-40]);
    protected 
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_120_70_ZR_17_Data 
        Pacejka_120_70_ZR_17_Data 
                                annotation (extent=[-80,80; -60,100]);
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_180_55_ZR_17_Data 
        Pacejka_180_55_ZR_17_Data 
                                annotation (extent=[-100,80; -80,100]);
    public 
    Motorcycle KTM_950(
        Rear_Wheel_data=Rear_Wheel_data,
        Dimension_MassPosition_data=Dimension_MassPosition_data,
        Rear_Pacejka_Friction_Data=Pacejka_180_55_ZR_17_Data,
        Front_Pacejka_Friction_Data=Pacejka_120_70_ZR_17_Data,
        Front_Suspension_data=Front_Suspension_data,
        Rear_Suspension_data=Rear_Suspension_data,
        xyz_init={0.40,0,0.3332 + 0.01},
        Front_Wheel_data=Front_Wheel_data) 
                          annotation (extent=[12,-30; 48,8]);
    public 
      Modelica.Blocks.Sources.Constant const(k=0) 
        annotation (extent=[8,-20; 16,-10]);
    protected 
      MotorcycleDynamics.Chassis.Data.KTM_950_Chassis_Data Chassis_Data 
        annotation (extent=[60,60; 80,80]);
      
      Suspension.Front_Suspension.Data.KTM_950_Front_Suspension_data 
        Front_Suspension_data annotation (extent=[40,80; 60,100]);
      Suspension.Rear_Suspension.Data.KTM_950_Rear_Suspension_Data 
        Rear_Suspension_data(                                  s_unstretched=0.25,
          Spring=[-0.0746,-22640; -0.070,-15950; -0.069,-15470; -0.0675,-14655;
            -0.065,-13740; -0.060,-12300; -0.050,-9900; -0.0465,-9025; -0.040,-8050;
            -0.030,-6550; -0.020,-5050; -0.010,-3550; 0,2050; 0.010,3550; 0.020,
            5050; 0.030,6550; 0.040,8050; 0.0465,9025; 0.050,9900; 0.060,12300;
            0.065,13740; 0.0675,14655; 0.069,15470; 0.070,15950; 0.0746,22640]) 
                             annotation (extent=[80,80; 100,100]);
      inner 
        MotorcycleDynamics.Rear_Swinging_Arm.Data.KTM_950_Rear_Swingin_Arm_Data
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Wheel.Data.KTM_950_Rear_Wheel_Data Rear_Wheel_data 
        annotation (extent=[40,60; 60,80]);
      MotorcycleDynamics.Wheel.Data.KTM_950_Front_Wheel_Data Front_Wheel_data 
        annotation (extent=[80,60; 100,80]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed(
        tableOnFile=true,
        tableName="vx_tab",
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
        annotation (extent=[-116,0; -96,20],   rotation=0);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Steer(
        tableOnFile=true,
        tableName="steer_tab",
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
                     annotation (extent=[80,20; 100,40], rotation=180);
      Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,0; 0.3,0.2; 6,
            13.3217*0 + 16; 10,13.2117*0 + 16; 10,10; 14,1; 15,0; 16,0]) 
                    annotation (extent=[-116,-30; -96,-10]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Roll(
        tableOnFile=true,
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        tableName="roll_tab",
        startTime=10,
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat") 
                     annotation (extent=[-80,40; -60,60],rotation=0);
      
      Modelica.Blocks.Math.Add add annotation (extent=[-78,-16; -58,4]);
      Driver.Joystick_Driver_Real_GR joystick_Driver_Real_GR(
          Dimension_MassPosition_data=Dimension_MassPosition_data, k=0) 
        annotation (extent=[-2,16; 18,36]);
      Modelica.Mechanics.Rotational.Torque torque 
        annotation (extent=[42,28; 62,48], rotation=270);
      Driver.Speed_Control speed_Control(
        k=-35 - 20*0,
        Ti=0.07,
        k_fw=-20) 
        annotation (extent=[-48,-20; -28,0]);
      Modelica.Mechanics.Rotational.Torque torque1 
        annotation (extent=[-16,-34; 4,-14]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed1(
        tableOnFile=true,
        tableName="vx_tab",
        fileName=
            "C:/Documents and Settings/Administrator/Desktop/ktm/tables.mat",
        startTime=8.75) 
        annotation (extent=[-100,-60; -80,-40],rotation=0);
      Braking_System.ABS aBS(best_slip=0.06, Hz=200) 
        annotation (extent=[26,-62; 46,-42]);
      Modelica.Blocks.Interfaces.RealOutput Roll_SP[size(Roll.y, 1)] 
        annotation (extent=[-44,82; -24,102]);
      Modelica.Blocks.Interfaces.RealOutput Speed_SP 
        annotation (extent=[-108,22; -88,42]);
      Modelica.Blocks.Interfaces.RealOutput Moto_Sensor[6] 
        annotation (extent=[-50,-108; -30,-88]);
      Modelica.Mechanics.Rotational.Sensors.AngleSensor angleSensor 
        annotation (extent=[84,-8; 104,12]);
      Modelica.Blocks.Interfaces.RealOutput Steer_SP[size(Steer.y, 1)] 
        annotation (extent=[112,38; 132,58]);
      Modelica.Blocks.Interfaces.RealOutput Steer_Sensor 
        annotation (extent=[118,-8; 138,12]);
      Modelica.Mechanics.MultiBody.Sensors.RelativeSensor relativeSensor(
          get_a_rel=true, get_z_rel=true) 
        annotation (extent=[86,-34; 106,-14], rotation=90);
      Modelica.Blocks.Interfaces.RealOutput Acceleration[size(relativeSensor.y,
        1)] annotation (extent=[120,-34; 140,-14]);
  equation 
  // torque_Control.Rear_Slip=KTM_950.Pin1.slip;
  torque.tau= if time<12.97 then 0 else Roll.y[1]*(35*0+45*0+55)+(Roll.y[1]-KTM_950.Sensor[6])*(55*0+50);
      
      connect(KTM_950.Pin2, pacejka_Friction_Model1.Pin)  annotation (points=[68.16,
            -31.9; 68.16,-35.95; 68,-35.95; 68,-40.6],     style(color=3,
          rgbcolor={0,0,255}));
      connect(KTM_950.Pin1, pacejka_Friction_Model.Pin)  annotation (points=[6.6,
            -38.36; 6.6,-42.18; 6,-42.18; 6,-46.5],           style(color=3,
          rgbcolor={0,0,255}));
      connect(Aerodynamics1.frame_a, KTM_950.Pressure_center)  annotation (points=[-11,81;
            -11,49.5; 38.64,49.5; 38.64,1.92],          style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
      connect(const.y, KTM_950.Rear_Brake1)  annotation (points=[16.4,-15; 22,
            -15; 22,-21.26; 26.04,-21.26],
                                    style(color=74, rgbcolor={0,0,127}));
      connect(timeTable1.y, add.u2) annotation (points=[-95,-20; -90,-20; -90,
            -12; -80,-12], style(color=74, rgbcolor={0,0,127}));
      connect(add.u1, Speed.y[1]) annotation (points=[-80,0; -90,0; -90,10; -95,
            10], style(color=74, rgbcolor={0,0,127}));
      connect(joystick_Driver_Real_GR.frame_Seaddle, KTM_950.frame_Saddle1) 
        annotation (points=[7,17; 7,4.5; 26.22,4.5; 26.22,-8.53], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(joystick_Driver_Real_GR.flange_steering, KTM_950.Steering) 
        annotation (points=[17,29; 53.22,29; 53.22,6.67], style(color=0,
            rgbcolor={0,0,0}));
      connect(joystick_Driver_Real_GR.Sensor1, KTM_950.Sensor) annotation (
          points=[-1,25; -10,25; -10,-33.61; -1.5,-33.61], style(color=74,
            rgbcolor={0,0,127}));
      connect(torque.flange_b, KTM_950.Steering) annotation (points=[52,28; 52,
            6.67; 53.22,6.67], style(color=0, rgbcolor={0,0,0}));
      connect(speed_Control.friction_Connector, KTM_950.Pin1) annotation (
          points=[-48,-17; -48,-38.36; 6.6,-38.36], style(
          color=3,
          rgbcolor={0,0,255},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(KTM_950.Sensor, speed_Control.Sensor) annotation (points=[-1.5,
            -33.61; -54,-33.61; -54,-5; -49,-5], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(add.y, speed_Control.Speed_SP) annotation (points=[-57,-6; -56,-6;
            -56,-1; -49,-1], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(torque1.flange_b, KTM_950.Rear_Joint) annotation (points=[4,-24;
            4,-27.53; 7.5,-27.53], style(
          color=0,
          rgbcolor={0,0,0},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(speed_Control.Rear_Torque, torque1.tau) annotation (points=[-27,
            -1; -18,-1; -18,-24], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(Speed1.y[1], speed_Control.FW) annotation (points=[-79,-50; -52,
            -50; -52,-11; -48,-11], style(
          color=74,
          rgbcolor={0,0,127},
          fillColor=6,
          rgbfillColor={255,255,0},
          fillPattern=1));
      connect(KTM_950.Front_Brake1, aBS.to_Brake) annotation (points=[49.8,6.48;
            46,6.48; 46,-26; 52,-26; 52,-51; 45,-51], style(color=74, rgbcolor=
              {0,0,127}));
      connect(KTM_950.Pin2, aBS.Slip) annotation (points=[68.16,-31.9; 68.16,
            -36; 27,-36; 27,-43], style(color=3, rgbcolor={0,0,255}));
      connect(speed_Control.Brake, aBS.u) annotation (points=[-27,-17.2; -24,
            -17.2; -24,-58; 18,-58; 18,-51; 27,-51], style(color=74, rgbcolor={
              0,0,127}));
      connect(Roll.y, Roll_SP) annotation (points=[-59,50; -46,50; -46,92; -34,
            92], style(color=74, rgbcolor={0,0,127}));
      connect(add.y, Speed_SP) annotation (points=[-57,-6; -54,-6; -54,32; -98,
            32], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Sensor, Moto_Sensor) annotation (points=[-1.5,-33.61; -40,
            -33.61; -40,-98], style(color=74, rgbcolor={0,0,127}));
      connect(KTM_950.Steering, angleSensor.flange_a) annotation (points=[53.22,
            6.67; 67.61,6.67; 67.61,2; 84,2], style(color=0, rgbcolor={0,0,0}));
      connect(Steer.y, Steer_SP) annotation (points=[79,30; 72,30; 72,48; 122,
            48], style(color=74, rgbcolor={0,0,127}));
      connect(angleSensor.phi, Steer_Sensor) annotation (points=[105,2; 128,2],
          style(color=74, rgbcolor={0,0,127}));
      connect(relativeSensor.frame_b, KTM_950.frame_Saddle1) annotation (points=
           [96,-14; 62,-14; 62,-8.53; 26.22,-8.53], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(relativeSensor.frame_a, KTM_950.frame_rear_hub1) annotation (
          points=[96,-34; 54,-34; 54,-24.3; 9.12,-24.3], style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(relativeSensor.y, Acceleration) annotation (points=[107,-24; 130,
            -24], style(color=74, rgbcolor={0,0,127}));
  end KTM_950_Roll_II;
    
  model KTM_950_Steer 
      import MotorcycleDynamics.Environments.Road;
      import SurfaceMaterial;
    constant Real pi= Modelica.Constants.pi;
    annotation (
      uses(
        VehicleDynamics(version="0.8"),
        Modelica(version="1.6"),
        ModelicaAdditions(version="1.5")),
      Diagram,
      Icon,
      experiment(
          StopTime=15,
          NumberOfIntervals=100,
          Tolerance=1e-006),
      experimentSetupOutput(equdistant=false, events=false),
      DymolaStoredErrors,
        Commands(file="Temp.mos" "Temp"));
    inner Modelica.Mechanics.MultiBody.World world(
      n={0,0,-1},
      axisLength=0.2,
      enableAnimation=true,
      animateGravity=false,
      animateWorld=true,
      label1="",
      label2="",
      axisColor_x={0,0,0},
      axisColor_y={0,0,0},
      axisColor_z={0,0,0}) annotation (extent=[-100,-100; -80,-80]);
    inner Road road(
        d=0.01,
        a=55,
        b=50,
        choice=0) 
             annotation (extent=[46, -100; 100, -58]);
    public 
      inner parameter Supermotard_Dimension_MassPosition_Data 
        Dimension_MassPosition_data 
        annotation (extent=[60,80; 80,100]);
      Aerodynamics.Aerodynamics Aerodynamics1 
        annotation (extent=[-20,80; 0,100]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model(                                                  Fz0=1144) 
        annotation (extent=[-24,-36; -12,-26]);
      Wheel.Friction_Model.Pacejka.Pacejka_Friction_Model 
        pacejka_Friction_Model1(                                                  Fz0=1111) 
        annotation (extent=[38,-32; 50,-20]);
    protected 
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_120_70_ZR_17_Data 
        Pacejka_120_70_ZR_17_Data 
                                annotation (extent=[-80,80; -60,100]);
    parameter Wheel.Friction_Model.Pacejka.Data.Pacejka_180_55_ZR_17_Data 
        Pacejka_180_55_ZR_17_Data 
                                annotation (extent=[-100,80; -80,100]);
    public 
    Motorcycle KTM_950(
        Rear_Wheel_data=Rear_Wheel_data,
        Dimension_MassPosition_data=Dimension_MassPosition_data,
        Rear_Pacejka_Friction_Data=Pacejka_180_55_ZR_17_Data,
        Front_Pacejka_Friction_Data=Pacejka_120_70_ZR_17_Data,
        Front_Suspension_data=Front_Suspension_data,
        Rear_Suspension_data=Rear_Suspension_data,
        xyz_init={0.40,0,0.3332 + 0.01},
        Front_Wheel_data=Front_Wheel_data) 
                          annotation (extent=[-12,-10; 24,28]);
    public 
      Modelica.Blocks.Sources.Constant const(k=0) 
        annotation (extent=[-16,0; -8,10]);
    Driver.Torque_Control torque_Control(
        Tstart=-1,
        Tfinish=0,
        k=20,
        T=0.001)                         annotation (extent=[-56,-8; -40,8]);
      MotorcycleDynamics.Chassis.Data.KTM_950_Chassis_Data Chassis_Data 
        annotation (extent=[60,60; 80,80]);
    protected 
      Suspension.Front_Suspension.Data.KTM_950_Front_Suspension_data 
        Front_Suspension_data annotation (extent=[40,80; 60,100]);
      Suspension.Rear_Suspension.Data.KTM_950_Rear_Suspension_Data 
        Rear_Suspension_data(                                  s_unstretched=0.25,
          Spring=[-0.0746,-22640; -0.070,-15950; -0.069,-15470; -0.0675,-14655;
            -0.065,-13740; -0.060,-12300; -0.050,-9900; -0.0465,-9025; -0.040,-8050;
            -0.030,-6550; -0.020,-5050; -0.010,-3550; 0,2050; 0.010,3550; 0.020,
            5050; 0.030,6550; 0.040,8050; 0.0465,9025; 0.050,9900; 0.060,12300;
            0.065,13740; 0.0675,14655; 0.069,15470; 0.070,15950; 0.0746,22640]) 
                             annotation (extent=[80,80; 100,100]);
      inner 
        MotorcycleDynamics.Rear_Swinging_Arm.Data.KTM_950_Rear_Swingin_Arm_Data
        Rear_Swinging_Arm_data annotation (extent=[20,80; 40,100]);
      Wheel.Data.KTM_950_Rear_Wheel_Data Rear_Wheel_data 
        annotation (extent=[40,60; 60,80]);
      MotorcycleDynamics.Wheel.Data.KTM_950_Front_Wheel_Data Front_Wheel_data 
        annotation (extent=[80,60; 100,80]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Speed(
        tableOnFile=true,
        tableName="vx_tab",
        fileName="C:/Documents and Settings/Filippo/Desktop/ktm/tables.mat",
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        startTime=10) 
        annotation (extent=[-100,0; -80,20],   rotation=0);
      Modelica.Mechanics.Rotational.Position position 
        annotation (extent=[40,20; 60,40], rotation=180);
      Modelica.Blocks.Sources.TimeTable timeTable(table=[0,0; 0.3,-30; 2,-700;
            2,0; 2.1,0]) 
                    annotation (extent=[-100,-40; -80,-20]);
      Modelica.Blocks.Math.Feedback feedback 
        annotation (extent=[70,24; 84,38], rotation=180);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Steer(
        tableOnFile=true,
        tableName="steer_tab",
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        fileName="C:/Documents and Settings/Filippo/Desktop/ktm/tables.mat",
        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        startTime=10) 
                     annotation (extent=[88,26; 100,36], rotation=180);
      Modelica.Blocks.Math.Add add 
        annotation (extent=[-74,-2; -60,14], rotation=0);
      Modelica.Blocks.Sources.TimeTable timeTable1(table=[0,0; 0.3,0.5; 8,13;
            10,13; 10,0]) 
                    annotation (extent=[-100,-20; -80,0]);
    public 
      Modelica.Blocks.Sources.CombiTimeTable Roll(
        tableOnFile=true,
        table=[0.0,0.0; 0.0,0.0; 0.0,0.0],
        fileName="C:/Documents and Settings/Filippo/Desktop/ktm/tables.mat",
        smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
        extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
        tableName="roll_tab",
        startTime=10) 
                     annotation (extent=[-40,-80; -20,-60],
                                                         rotation=0);
      Braking_System.ABS aBS(Hz=100) 
        annotation (world(x_label(
                    extent =             [-4,-36; 16,-16])));
      Driver.Passive_Driver passive_Driver 
        annotation (world(x_label(
                    extent =             [-12,34; 8,54])));
  equation 
  position.phi_ref = if time<10 then 0 else feedback.y;
  //feedback.u2 = -0.341543*((Modelica.Math.atan(2*(time-2))+pi/2)/pi);
  feedback.u2 = -0.0226636;
  torque_Control.Rear_Slip=KTM_950.Pin1.slip;
      
      connect(KTM_950.Pin2, pacejka_Friction_Model1.Pin)  annotation (points=[44.16,
            -11.9; 44.16,-15.95; 44,-15.95; 44,-20.6],     style(color=3,
          rgbcolor={0,0,255}));
      connect(KTM_950.Pin1, pacejka_Friction_Model.Pin)  annotation (points=[-17.4,
            -18.36; -17.4,-22.18; -18,-22.18; -18,-26.5],     style(color=3,
          rgbcolor={0,0,255}));
      connect(Aerodynamics1.frame_a, KTM_950.Pressure_center)  annotation (points=[-11,81;
            -11,69.5; 14.64,69.5; 14.64,21.92],         style(
        color=10,
        rgbcolor={95,95,95},
        thickness=2));
      connect(const.y, KTM_950.Rear_Brake1)  annotation (points=[-7.6,5; -2,5;
            -2,-1.26; 2.04,-1.26],  style(color=74, rgbcolor={0,0,127}));
      connect(position.flange_b, KTM_950.Steering)    annotation (points=[40,30;
            29.22,30; 29.22,26.67], style(color=0, rgbcolor={0,0,0}));
      connect(feedback.u1, Steer.y[1]) annotation (points=[82.6,31; 87.4,31],
          style(color=74, rgbcolor={0,0,127}));
      connect(add.y, torque_Control.SP_Speed) annotation (points=[-59.3,6;
            -57.25,6; -57.25,7.2; -55.2,7.2], style(color=74, rgbcolor={0,0,127}));
      connect(Speed.y[1], add.u1) annotation (points=[-79,10; -77.2,10; -77.2,
            10.8; -75.4,10.8], style(color=74, rgbcolor={0,0,127}));
      connect(timeTable1.y, add.u2) annotation (points=[-79,-10; -75.4,-10;
            -75.4,1.2], style(color=74, rgbcolor={0,0,127}));
      connect(torque_Control.flange_rear_hub, KTM_950.Rear_Joint) annotation (
          points=[-40.8,-7.2; -29.4,-7.2; -29.4,-7.53; -16.5,-7.53], style(
            color=0, rgbcolor={0,0,0}));
      connect(torque_Control.frame_Seaddle, KTM_950.frame_Saddle1) annotation (
          points=[-40,2.4; -34,2.4; -34,2; -24,2; -24,20; 2.22,20; 2.22,11.47],
          style(
          color=10,
          rgbcolor={95,95,95},
          thickness=2));
      connect(aBS.to_Brake, KTM_950.Front_Brake1) annotation (world(x_label(
          points =             [15,-25; 18,-25; 18,26.48; 25.8,26.48],
          style(world(x_label(color =             74, rgbcolor =             {0,
              0,127}))))));
      connect(torque_Control.y1, aBS.u) annotation (world(x_label(
                                                    points =             [
            -41.12,7.2; -41.12,14; -46,14; -46,-42; -6,-42; -6,-25; -3,-25],
          style(world(x_label(color =             74, rgbcolor =             {0,
              0,127}))))));
      connect(KTM_950.Pin1, aBS.Slip) annotation (world(x_label(
                                                  points =             [-17.4,
            -18.36; -10.7,-18.36; -10.7,-17; -3,-17], style(world(x_label(
            color =             3, rgbcolor =             {0,0,255}))))));
      connect(passive_Driver.frame_Seaddle, KTM_950.frame_Saddle1) annotation (world(
            x_label(
          points =             [-3,35; -3,23.5; 2.22,23.5; 2.22,11.47],
          style(world(x_label(
          color =             10,
          rgbcolor =             {95,95,95},
          thickness =             2))))));
  end KTM_950_Steer;
  end temp;
  
end MotorcycleDynamics;
