<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Zoo Management System</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

</head>

<body>

<div class="app">

    <!-- Sidebar -->

    <aside class="sidebar">

        <div class="logo">
            🦁 Zoo Management
        </div>

        <nav class="menu">

            <a href="${pageContext.request.contextPath}/dashboard" class="active">
                🏠 Dashboard
            </a>

            <a href="${pageContext.request.contextPath}/animals">
                🐾 Animals
            </a>

            <a href="${pageContext.request.contextPath}/enclosures">
                🏡 Enclosures
            </a>

            <a href="${pageContext.request.contextPath}/staff">
                👨‍💼 Staff
            </a>

            <a href="#">
                🩺 Health Records
            </a>

            <a href="${pageContext.request.contextPath}/feeding">
                🍖 Feeding
            </a>

            <a href="#">
                👥 Visitors
            </a>

            <a href="#">
                🎟️ Tickets
            </a>

            <a href="#">
                📊 Reports
            </a>

        </nav>

    </aside>


    <!-- Main Content -->

    <main class="main">

        <!-- Topbar -->

        <header class="topbar">

            <div class="page-title">
                Dashboard
            </div>

            <div class="user">
                Administrator 👤
            </div>

        </header>


        <!-- Page Content -->

        <section class="content">

            <div class="welcome">

                <h1>
                    Welcome to Zoo Management System
                </h1>

                <p>
                    Manage animals, staff, enclosures,
                    health records and visitors from one place.
                </p>

            </div>


            <!-- Dashboard Cards -->

            <div class="cards">

                <div class="card">

                    <div class="card-title">
                        Total Animals
                    </div>

                    <div class="card-value">
                        <%= request.getAttribute("totalAnimals") == null
                                ? "Unavailable"
                                : request.getAttribute("totalAnimals") %>
                    </div>

                </div>


                <div class="card">

                    <div class="card-title">
                        Enclosures
                    </div>

                    <div class="card-value">
                        Coming soon
                    </div>

                </div>


                <div class="card">

                    <div class="card-title">
                        Staff Members
                    </div>

                    <div class="card-value">
                        Coming soon
                    </div>

                </div>


                <div class="card">

                    <div class="card-title">
                        Visitors
                    </div>

                    <div class="card-value">
                        Coming soon
                    </div>

                </div>

            </div>


            <div class="table-container">

                <h2>
                    Available features
                </h2>

                <p>Animal records can be added, viewed, edited, and deleted from the Animals page.</p>
                
            </div>

        </section>

    </main>

</div>

</body>

</html>