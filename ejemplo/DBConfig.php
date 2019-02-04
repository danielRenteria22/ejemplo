<?php

    function getConexionUsuario(){
        $servername = "localhost";
        $password = "";
        $DBName = "rteacher";

        $userUN = "root";
        $userPW = "";
        return $connection=mysqli_connect($servername,$userUN,$userPW,$DBName);
    }

    function getConexionAdmin(){
        $servername = "localhost";
        $password = "";
        $DBName = "rteacher";
        $adminUN = "root";
        $adminPW = "";
        return $connection=mysqli_connect($servername,$adminUN,$adminPW,$DBName);
    }

    function getMySQLi(){
        $servername = "localhost";
        $DBName = "rteacher";

        $userUN = "root";
        $userPW = "";
        return new mysqli($servername, $userUN, $userPW, $DBName);
    }
  
?>