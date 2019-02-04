
<?php
    session_start();
    $id_escuela = $_GET["id_escuela"];
    $id_escuela_user = $_GET["id_escuela"];
    /*if(isset($_SESSION["id_usuario"])){
        $id_escuela_user = $_SESSION["id_escuela"];
        if($id_escuela != $id_escuela_user){
            echo "<script>";
            echo "alert(\"¡Solo puedes calificar maestros de tu escuela!\");\n";
            echo "window.history.back();";
            echo "</script>";
        }

        $bloqueado = $_SESSION["bloqueado"];
            if($bloqueado == 1){
                echo "<script>";
                echo "alert(\"¡Lo sentimo! Haz sido bloqueado :(\");\n";
                echo "window.history.back();";
                echo "</script>";
            }
    } else{
        echo "<script>";
        echo "alert(\"¡Necesitas registrarte para agregar maestros!\");\n";
        echo "window.location.href = \"log_in.php\"";
        echo "</script>";
    }*/
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
			 <!-- Left Column -->
			<div class='w3-col m3'>
			<!-- Profile -->
			<div class='w3-card w3-round w3-white'>
				<div class='w3-container'>
					<h4 class='w3-center'>RTeacher</h4>
					<p class='w3-center'><img src='./W3.CSS Template_files/avatar3.png' class='w3-circle' style='height:106px;width:106px' alt='Avatar'></p>
					<hr>
				</div>
			</div>
			<br>
			<!-- End Left Column -->
			</div>
		
			<!-- Middle Column -->
			<div class='w3-col m7'>
			<div class='w3-container w3-card w3-white w3-round w3-margin'><br>

<?php
    include "DBConfig.php";

    //Conexion con la base de datos
    $conn = getConexionUsuario();
    if(mysqli_connect_errno($conn))
    {
        echo 'No se pudo hacer la conexión con la base de datos';
        exit;
    }
    $id_maestro = $_GET["id_maestro"];

    //Se obtienen todos los departamentos, y las materias correspondientes
    //Para cada departameto se hace un select, pero se hace no visible
    //Cuando se seleccione un departaento, se hara visible el select correspondiente
    $id_departamentos = array();
    $nombre_departamentos = array();
    $cont = 0;
    $sql = "SELECT * FROM departamento";
    $result = mysqli_query($conn, $sql);
    while($row = mysqli_fetch_array($result)){
        $id_departamentos[$cont] = $row[0];
        $nombre_departamentos[$cont] = $row[1];
        $cont++;
    }
    
    echo "<form action=\"calificarDB.php?id_maestro=$id_maestro&cont=$cont&id_escuela=$id_escuela\" method = \"post\">";
    //Select de todos los departamentos
    echo "<h2>Departamento</h2>";
    echo "<select onchange=\"departamentoSeleccionado($cont)\" id = 'departamentos' name = \"departamento\" >\n";
    for($i = 0; $i < $cont; $i++){
        $nom_dep = $nombre_departamentos[$i];
        echo "  <option value = $i>$nom_dep\n";
    }
    echo "</select><br>\n";

    //Hacemos un select para cada departamento
    echo "<h2>Materia</h2>";
    for($i = 0; $i < $cont; $i++){
        $nom_dep = $nombre_departamentos[$i];
        $id_dep = $id_departamentos[$i];
        echo "<select name = 'd$i'  id = 'd$i' style=\"visibility:hidden\">";
        $sql = "SELECT 	id_materias,Nombre FROM materias WHERE id_departamento = $id_dep ORDER BY Nombre";
        $result = mysqli_query($conn, $sql);
        while($row = mysqli_fetch_array($result)){
            $id_materia = $row[0];
            $nombre_materia = $row[1];
            echo "  <option value = $id_materia>$nombre_materia\n";
        }
        echo "</select><br>\n";
    }

    
    
    
?>

Calificacion general<input type="range" min="1" max="10" value="5"  id="calificacion_general" name = "calificacion_general">
<p>Valor: <span id="cal_gral">5</span></p><br>

Dificultad<input type="range" min="1" max="10" value="5"  id="dificultad" name = "difucultad"><br>
<p>Valor: <span id="dif">5</span></p><br>

Calificacion obtenida<input type="range" min="1" max="100" value="70"  id="calificacion_obtenida" name = "calificacion_obtenida"><br>
<p>Valor: <span id="cal_obt">70</span></p><br>

<p>¿Lo volveria a elegir?</p><br>
<input type="radio" name="elegir" value="1" required > Si<br>
<input type="radio" name="elegir" value="0" required > No<br>

<p>Comentario</p>
<textarea rows="4" cols="50" name = "comentario" required></textarea><br>

<h2>Descripciones rapidas</h2>
<?php
    //Check boxes para etiquetas
    $sql = "SELECT * FROM descripciones_rapidas";
    $result = mysqli_query($conn, $sql);
    $contDesc = 1;
    while($row = mysqli_fetch_array($result)){
        $id_desc = $row[0];
        $desc = $row[1];
        echo "<input type=\"checkbox\" name=\"desc$contDesc\" value=\"$id_desc\"> $desc<br>";
        $contDesc++;
    }
    $contDesc--;
     //Terminar la conexion con la base datos
     echo "<input type=\"hidden\" name=\"contDesc\" value=\"$contDesc\" />";
     mysqli_close($conn);
?>

<input type="submit" value = "Calificar"><br>
<p></p>

<script>
    var calificacion_obtenida = document.getElementById("calificacion_obtenida");
    var calificacion_obtenida_output = document.getElementById("cal_obt");
    calificacion_obtenida_output.innerHTML = calificacion_obtenida.value;

    calificacion_obtenida.oninput = function() {
        calificacion_obtenida_output.innerHTML = this.value;
    }

    var dificultad = document.getElementById("dificultad");
    var dificultad_output = document.getElementById("dif");
    dificultad_output.innerHTML = dificultad.value;

    dificultad.oninput = function() {
        dificultad_output.innerHTML = this.value;
    }

    var cal_gral = document.getElementById("calificacion_general");
    var cal_gral_output = document.getElementById("cal_gral");
    cal_gral_output.innerHTML = cal_gral.value;

    cal_gral.oninput = function() {
        cal_gral_output.innerHTML = this.value;
    }   
</script>



</form>			</div> 
			<!-- End Middle Column -->
			</div>

		<!-- End Grid -->
		</div>
  
	<!-- End Page Container -->
	</div>
<br>
    
</body>
</html>


<script>
    function departamentoSeleccionado(numDep){
        var departamento = document.getElementById("departamentos").value;
        var nombreDep;
        for(var i = 0; i < numDep; i++){
            nombreDep = "d" + i;
            document.getElementById(nombreDep).style.visibility = "hidden"; 
        }

        nombreDep = "d" + departamento;
        document.getElementById(nombreDep).style.visibility = "visible"; 
    }
    
</script>