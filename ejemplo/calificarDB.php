<?php
    include "DBConfig.php";

    //Conexion con la base de datos
    //En el archivo DBConfig.php se guardan todos los datos de la DB
    //en caso de que se tengan que hacer cambios
    $conn = getMySQLi();
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
        exit;
    } 

    $id_maestro = $_GET["id_maestro"];
    $id_usuario = 1;
    $cont = $_GET["cont"];
    $id_escuela = $_GET["id_escuela"];

    $id_dep = $_POST["departamento"];
    $id_materia = $_POST["d$id_dep"];
    $cal_gral = $_POST["calificacion_general"];
    $dificultad = $_POST["difucultad"];
    $cal_obt = $_POST["calificacion_obtenida"];
    $elegir = $_POST["elegir"];
    $comentario = $_POST["comentario"];

    $contDesc = $_POST["contDesc"];


    //La sentencia INSERT para agregar la calificacion a la base de datos
    $sqlCrearCalificacion = "INSERT INTO calificacion (id_maestro,id_usuario,id_materias,calificacionGeneral,Dificultad,
    calificacion_obtenida,volver_a_tomar,comentario) VALUES ($id_maestro,$id_usuario,$id_materia,$cal_gral,$dificultad,
    $cal_obt,$elegir,'$comentario');";
    //Se obtiene el ID  de la ultima requision para agregar los pasos nulos en estado_req
	if ($conn->query($sqlCrearCalificacion) === TRUE) {
    	$id_calificacion = $conn->insert_id;
	} else {
        echo "Error: " . $sqlCrearCalificacion . "<br>" . $conn->error;
        exit;
    }
    
    //Cada descripcion rapida se guarda como un resgistro. Aqui se crea el INSERT para agregar todas las
    //descripciones que se hayan usado
    $sqlInsertarDesc = "INSERT INTO descripcion_calificacion (id_calificacion,id_descripcioon) VALUES ";
    $descElegidas = FALSE;
    //Agrear las descripciones rapidas
    for($i = 1; $i <= $contDesc; $i++){
        if(isset($_POST["desc$i"])){
            $descElegidas = TRUE;
            $idDesc = $_POST["desc$i"];
            $sqlInsertarDesc = $sqlInsertarDesc . "($id_calificacion,$idDesc),";
        }
    }
    $length = strlen($sqlInsertarDesc);
	$sqlInsertarDesc = substr($sqlInsertarDesc,0,$length-1);
	$sqlInsertarDesc = $sqlInsertarDesc . ";";


    if($descElegidas){
        //echo $sqlInsertarDesc;
        if ($conn->query($sqlInsertarDesc) === TRUE) {
            
        } else {
            echo "Error: " . $sqlInsertarDesc . "<br>" . $conn->error;
            exit;
        }
    }
    header("Location: ver_maestro.php?id_maestro=$id_maestro&id_escuela=$id_escuela");

    $conn->close();


?>