<?php
session_start();
//if(isset($_SESSION["id_usuario"])){
if(true){
    $id_escula_user = 1; //$_SESSION["id_escuela"];
    $id_usuario = 1; //$_SESSION["id_usuario"];
}
 
$id_maestro =  39; //$_GET["id_maestro"];
$id_escuela = 1; //$_GET["id_escuela"];
?>

<!DOCTYPE html>
<html lang="es">
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><title>RTeacher</title>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="./W3.CSS Template_files/w3.css">
<link rel="stylesheet" href="./W3.CSS Template_files/w3-theme-blue-grey.css">
<link rel="stylesheet" href="./W3.CSS Template_files/css">
<link rel="stylesheet" href="./W3.CSS Template_files/font-awesome.min.css">
<style>
html,body,h1,h2,h3,h4,h5 {font-family: "Open Sans", sans-serif}
</style>
</head>
<body class="w3-theme-l5">
	<!-- Navbar -->
	<div class="w3-top">
	<div class="w3-bar w3-theme-d2 w3-left-align w3-large">
	<a class="w3-bar-item w3-button w3-hide-medium w3-hide-large w3-right w3-padding-large w3-hover-white w3-large w3-theme-d2" href="javascript:void(0);" onclick="openNav()"><i class="fa fa-bars"></i></a>
	<a href="ver_escuelas.php" class="w3-bar-item w3-button w3-padding-large w3-theme-d4"><i class="fa fa-home w3-margin-right"></i>RTeacher</a>
	<a href="busqueda_avanzada.php?id_escuela=<?php echo $id_escuela;?>" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Busqueda"><i class="fa fa-search"></i></a>
	<a href="maestros.php?idEscuela=<?php echo $id_escuela;?>" class="w3-bar-item w3-button w3-hide-small w3-padding-large w3-hover-white" title="Ver Maestros"><i class="fa fa-user"></i></a>
	
	<a href="https://www.w3schools.com/w3css/tryw3css_templates_social.htm#" class="w3-bar-item w3-button w3-hide-small w3-right w3-padding-large w3-hover-white" title="My Account">
		<img src="./W3.CSS Template_files/avatar2.png" class="w3-circle" style="height:23px;width:23px" alt="Avatar">
	</a>
	</div>
	</div>

	<!-- Navbar on small screens -->
	<div id="navDemo" class="w3-bar-block w3-theme-d2 w3-hide w3-hide-large w3-hide-medium w3-large">
	<a href="ver_escuelas.php" class="w3-bar-item w3-button w3-padding-large">RTeacher</a>
	<a href="busqueda_avanzada.php?id_escuela=<?php echo $id_escuela;?>" class="w3-bar-item w3-button w3-padding-large">Busqueda</a>
	<a href="maestros.php?idEscuela=<?php echo $id_escuela;?>" class="w3-bar-item w3-button w3-padding-large">Ver Maestros</a>
	</div>
	
	<!-- Page Container -->
	<div class="w3-container w3-content" style="max-width:1400px;margin-top:80px">    
		<!-- The Grid -->
		<div class="w3-row">

    <?php
        include "DBConfig.php";

        //Conexion con la base de datos
        $conn = getConexionUsuario();
        if(mysqli_connect_errno($conn))
        {
            echo 'No se pudo hacer la conexión con la base de datos';
            exit;
        }
        
        $user_en_escuela = $id_escuela == $id_escula_user;

        //Obtenemos los datos genrales del maestro
        //Use varias procedimientos almecenados para calculaar el promedio de
        //algunos parametros de califcacion de los maestros
        $sql = "SELECT 	Nombre, Apellidos, calcular_promedio_general(id_maestro), calcular_dificultad(id_maestro), 
        porcentaje_volver_a_tomar(id_maestro), id_maestro
        FROM maestro WHERE id_maestro = $id_maestro";
        $result = mysqli_query($conn, $sql);
        $row = mysqli_fetch_array($result);

        $nombre = $row[0];
        $apellios = $row[1];
        $cal_prom = $row[2];
        $dif_prom = $row[3];
        $volver_elegir = $row[4];

        $urlCalificar = "calificar.php?id_maestro=$id_maestro&id_escuela=$id_escuela";
		
		echo"<!-- Left Column -->
			 <div class='w3-col m3'>
				<!-- Profile -->
				<div class='w3-card w3-round w3-white'>
					<div class='w3-container'>
						<h4 class='w3-center'>$nombre $apellios</h4>
						<p class='w3-center'><img src='./W3.CSS Template_files/avatar3.png' class='w3-circle' style='height:106px;width:106px' alt='Avatar'></p>
						<hr>
						<p><i class='fa fa-users fa-fw w3-margin-right w3-text-theme'></i>Promedio: $cal_prom</p>
						<p><i class='fa fa-fire  fa-fw w3-margin-right w3-text-theme'></i>Dificultad promedio: $dif_prom</p>
						<p><i class='fa fa-history fa-fw w3-margin-right w3-text-theme'></i> L@ volverial a elegir: $volver_elegir%</p>
					</div>
				</div>
				<br>";

        //Seleccionamos las descripciones rapidas mas usadas
        //Cada calificacion que se le hace a un maestro contiene etiquetas llamadas descripciones rapidas
        //Esta consulta verifica cuales son las 3 descripciones más usdas con determinado maestro
        $sql = "SELECT c.Descripcion,count(*) as cont FROM calificacion a 
        INNER JOIN descripcion_calificacion b ON a.id_calificacion = b.id_calificacion 
        INNER JOIN descripciones_rapidas c on b.id_descripcioon = c.id_descripciones_rapidas 
        WHERE a.id_maestro =  $id_maestro 
        GROUP BY c.id_descripciones_rapidas 
        ORDER BY cont DESC
        LIMIT 3;";
        $result = mysqli_query($conn, $sql);
		echo "<!-- Interests --> 
			  <div class='w3-card w3-round w3-white w3-hide-small'>
				<div class='w3-container'>
					<p>Descripcion Rapidas Mas Usadas</p>
					<p>";
        
        while($row = mysqli_fetch_array($result)){
            $desc = $row[0];
            $cont = $row[1];
            echo "<span class='w3-tag w3-small w3-theme-d4'>$desc($cont)</span>";
        }
		
		echo "		</p>
				</div>
			</div>
			<br>";
        
		
		echo "<!-- End Left Column -->
			  </div>";
			  
		echo " <!-- Middle Column -->
			   <div class='w3-col m7'>";
		

        //Mostramos todas las calificaciones detalladas
        /**
         * 0 id_calificacion
         * 1 calificacion general
         * 2 dificultad
         * 3 calificacion obtenida
         * 4 volver a tomar
         * 5 comentario 
         * 6 materia
         * 7 Util
         * 8 Reportes
         */
        //echo "<h2>Calificaciones</h2>";

        //Todas las calificaciones que se han hecho a un maestro se obtienen aqui.
        //Se vereifica que el comentario no haya sido bloqueado
        $sql = "SELECT c.id_calificacion, c.calificacionGeneral,c.Dificultad,c.calificacion_obtenida,c.volver_a_tomar,
        c.comentario, m.nombre,contar_util(c.id_calificacion),contar_reportes(c.id_calificacion) FROM calificacion c
        INNER JOIN materias m ON c.id_materias = m.id_materias
        WHERE C.id_maestro = $id_maestro AND C.bloqueado = 0
        ORDER BY c.util DESC;";
        $resultCalficaciones = mysqli_query($conn, $sql);
        
        while($row = mysqli_fetch_array($resultCalficaciones)){
            $id_calificacion = $row[0];
            $cal_gral = $row[1];
            $dificultad = $row[2];
            $cal_obtenida = $row[3];
            $volver_a_tomar = $row[4];
            $comentario = $row[5];
            $materia = $row[6];
            $util = $row[7];
            $reportes = $row[8];

            $vat_string = "";
            if($volver_a_tomar == 1){
                $vat_string = "Si";
            } else{
                $vat_string = "No";
            }

            echo "<div class='w3-container w3-card w3-white w3-round w3-margin'><br>
					<img src='./W3.CSS Template_files/avatar5.png' alt='Avatar' class='w3-left w3-circle w3-margin-right' style='width:60px'>
					<span class='w3-right w3-opacity'>Es util $util | Reportes $reportes</span>
					<h4>Materia: $materia</h4><br>
					<hr class='w3-clear'>
					<p>Calificacion genral: $cal_gral/10</p>
					<p>Dificultad: $dificultad/10</p>
					<p>Calificacion obtenida: $cal_obtenida/100</p>
					<p>Volver a tomar: $vat_string</p>
					<p>$comentario</p>";

            //Obtenemos las descripciones rapidas usadas en esta calificacion
            $sql = "SELECT b.Descripcion FROM descripcion_calificacion a 
            INNER JOIN descripciones_rapidas b ON a.id_descripcioon = b.id_descripciones_rapidas
            WHERE a.id_calificacion = $id_calificacion;";
             $resultDesc = mysqli_query($conn, $sql);
			 echo "<button onclick='myFunction(&#39;c$id_calificacion&#39;)' class='w3-button w3-block w3-theme-l1 w3-left-align'><i class='fa fa-circle-o-notch fa-fw w3-margin-right'></i> Descripciones Rapidas</button>
					<div id='c$id_calificacion' class='w3-hide w3-container'>";
             while($rowDesc = mysqli_fetch_array($resultDesc)){
                $desc = $rowDesc[0];
                echo "<p>$desc</p>";
             }
             echo "</div>";
             //Si el usuario esta en esta escuela, se le dejara votar
             //Si ya votó, se le permitira quitar su voto
             if($user_en_escuela){
                $sqlVoto = "SELECT tipo FROM votos WHERE id_calificacion = $id_calificacion AND id_usuario = $id_usuario;";
                $resultVoto = mysqli_query($conn, $sqlVoto);
                $voto = mysqli_fetch_array($resultVoto);

                if($voto){
                    //Sio ya se va votado
                    $tipo = $voto[0];
                    if($tipo === "UTIL"){
                        //echo "<p>Te resulto util. <a href= 'eliminar_voto.php?id_cal=$id_calificacion'>Eliminar voto</a> </p>";
						$onclick = "location.href='eliminar_voto.php?id_cal=$id_calificacion';";
						echo "<button type='button' class='w3-button w3-theme-d1 w3-margin-bottom' onclick=$onclick><i class='fa fa-thumbs-up'></i> &nbsp;Eliminar voto</button> ";
                    } else{
                        //echo "<p>Reportaste este comentario. <a href= 'eliminar_voto.php?id_cal=$id_calificacion'>Eliminar voto</a> </p>";
						$onclick = "location.href='eliminar_voto.php?id_cal=$id_calificacion';";
						echo "<button type='button' class='w3-button w3-theme-d1 w3-margin-bottom' onclick=$onclick><i class='fa fa-thumbs-down'></i> &nbsp;Eliminar Voto</button> ";
                    }
                } else{
                    //echo "<p><a href = 'votar_util.php?id_cal=$id_calificacion&id_maestro=$id_maestro&id_escuela=$id_escuela'>Es util</a> | 
                    //<a href = 'reportar.php?id_cal=$id_calificacion&id_maestro=$id_maestro&id_escuela=$id_escuela'>Reportar</a></p>";
					$onClickU = "location.href='votar_util.php?id_cal=$id_calificacion&id_maestro=$id_maestro&id_escuela=$id_escuela';";
					echo "<button type='button' class='w3-button w3-theme-d1 w3-margin-bottom' onclick=$onClickU><i class='fa fa-thumbs-up'></i> &nbsp;Es util</button>";
					
					$onClickR = "location.href='reportar.php?id_cal=$id_calificacion&id_maestro=$id_maestro&id_escuela=$id_escuela';";
					echo "<button type='button' class='w3-button w3-theme-d1 w3-margin-bottom' onclick=$onClickR><i class='fa fa-thumbs-down'></i> &nbsp;Reportar</button>";
                }
				
				//echo "<button type='button' class='w3-button w3-theme-d1 w3-margin-bottom'><i class='fa fa-thumbs-up'></i> &nbsp;Es util</button> 
					  //<button type='button' class='w3-button w3-theme-d2 w3-margin-bottom'><i class='fa fa-thumbs-down'></i> &nbsp;Reportar</button> ";
                
             } 
             //Termina un comentario
             echo "</div>";
             
        }
        
		//Termina la seccion de calificaciones
		echo "<!-- End Middle Column -->
			  </div>";
			  
			  
		//***seccion derecha	  
		echo "<!-- Right Column -->
			  <div class='w3-col m2'>";
			  
				$onclickC = "location.href='$urlCalificar';";
			    echo "<div class='w3-card w3-round w3-white w3-center'>
						<div class='w3-container'>
							<p>¡Ayudanos a seguir creciendo!</p>
							<p><strong>Califica a este maestro</strong></p>
							<p><button class='w3-button w3-block w3-theme-l4' onclick=$onclickC>Calificar</button></p>
						</div>
					</div>
					<br>";
				$onclickB = "location.href='busqueda_avanzada.php?id_escuela=$id_escuela';";
				echo "<div class='w3-card w3-round w3-white w3-center'>
						<div class='w3-container'>
							<p>¿No es lo que buscabas?</p>
							<p><strong>Realiza una busqueda mas detallada</strong></p>
							<p><button class='w3-button w3-block w3-theme-l4' onclick=$onclickB>Buscar</button></p>
						</div>
					</div>
					<br>";
		
		echo "<!-- End Right Column -->
		</div>";
		
		//***Fin seccion derecha

        //Terminar la conexion con la base datos
        mysqli_close($conn);
    ?>
		<!-- End Grid -->
		</div>
  
	<!-- End Page Container -->
	</div>
<br>

<script>
// Accordion
function myFunction(id) {
    var x = document.getElementById(id);
    if (x.className.indexOf('w3-show') == -1) {
        x.className += ' w3-show';
        x.previousElementSibling.className += ' w3-theme-d1';
    } else { 
        x.className = x.className.replace('w3-show', '');
        x.previousElementSibling.className = 
        x.previousElementSibling.className.replace(' w3-theme-d1', '');
    }
}

// Used to toggle the menu on smaller screens when clicking on the menu button
function openNav() {
    var x = document.getElementById('navDemo');
    if (x.className.indexOf('w3-show') == -1) {
        x.className += ' w3-show';
    } else { 
        x.className = x.className.replace(' w3-show', '');
    }
}
</script>
	
</body>
	

</html>