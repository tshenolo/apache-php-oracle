<?php
    ini_set('display_errors', 1);
    error_reporting(E_ALL);

    // Connection information 
    $username = getenv('DB_USER');  
    $password = getenv('DB_PASS');  
    $host = getenv('DB_HOST');  
    $port = getenv('DB_PORT');  
    $service_name = getenv('DB_SERVICE_NAME');  
    $connection_string = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=$host)(PORT=$port))(CONNECT_DATA=(SERVICE_NAME=$service_name)))";

    // Connect to the database
    $conn = oci_connect($username, $password, $connection_string);

    // Check for successful connection
    if(!$conn) {
        $m = oci_error();
        echo $m['message'], "\n";
        exit;
    }

    // Prepare the query
    $query = 'SELECT name, email FROM users';
    $stid = oci_parse($conn, $query);

    // Execute the query
    oci_execute($stid);

    // Start the HTML table
    echo "<table border='1'>\n";
    echo "<tr><th>ID</th><th>Email</th></tr>";

    // Fetch the results and display them in the table
    while ($row = oci_fetch_assoc($stid)) {
        echo "<tr><td>" . $row['NAME'] . "</td><td>" . $row['EMAIL'] . "</td></tr>\n";
    }

    // End the HTML table
    echo "</table>\n";

    // Free the statement identifier and close the connection
    oci_free_statement($stid);
    oci_close($conn);
?>
