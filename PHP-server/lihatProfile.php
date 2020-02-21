<?php

require "../config/connect.php";

$response = array();

$sql = mysqli_query($con, "SELECT a.*, b.status FROM tb_users a left join level b on a.level = b.id");

while($a = mysqli_fetch_array($sql)){
	$b['id'] = $a['id'];
	$b['status'] = $a['status'];
	$b['email'] = $a['email'];
	$b['fullname'] = $a['fullname'];
	
	array_push($response, $b);
}

echo json_encode($response);

?>