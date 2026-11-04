<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="StudySwap.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Dashboard
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Quick Menu tiles on dashboard */
        .quick-menu-tile {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 20px 10px;
            border-radius: 10px;
            background: #ffffff;
            border: 1px solid #e6e9ef;
            text-decoration: none;
            color: #2c3e50;
            transition: all 0.25s ease;
            height: 100%;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }
        .quick-menu-tile:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.10);
            color: #0078d4;
            border-color: #0078d4;
        }
        .quick-menu-tile i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: #0078d4;
        }
        .quick-menu-tile span {
            font-weight: 600;
            font-size: 0.95rem;
        }
        .quick-menu-tile.logout-tile i {
            color: #dc3545;
        }
        .quick-menu-tile.logout-tile:hover {
            color: #dc3545;
            border-color: #dc3545;
        }
        .quick-menu-tile.logout-tile:hover i {
            color: #dc3545;
        }

        /* Clickable stat cards */
        .stat-card-link {
            text-decoration: none;
            color: inherit;
            display: block;
            height: 100%;
        }
        .stat-card-link:hover {
            color: inherit;
        }
        .stat-card-link:hover .card {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.10) !important;
            transition: all 0.25s ease;
        }
        .stat-card-link .card {
            transition: all 0.25s ease;
            cursor: pointer;
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col-12">
                <h2 class="text-primary">Welcome, <asp:Label ID="lblAdminNameDashboard" runat="server" Text="Admin User"></asp:Label>!</h2>
                <p class="text-muted">Here's a quick overview of your platform status.</p>
            </div>
        </div>

        <!-- ================= STAT CARDS (clickable) ================= -->
        <div class="row g-4">

            <!-- Total Students → ViewUsers.aspx -->
            <div class="col-sm-6 col-md-3">
                <a href="ViewUsers.aspx" class="stat-card-link">
                    <div class="card shadow-sm border-primary h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-user-graduate fa-3x text-primary mb-3"></i>
                            <h5 class="card-title">Total Students</h5>
                            <h3>
                                <asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label>
                            </h3>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Active Listings → ViewListing.aspx -->
            <div class="col-sm-6 col-md-3">
                <a href="ViewListing.aspx" class="stat-card-link">
                    <div class="card shadow-sm border-success h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-box fa-3x text-success mb-3"></i>
                            <h5 class="card-title">Active Listings</h5>
                            <h3>
                                <asp:Label ID="lblActiveListings" runat="server" Text="0"></asp:Label>
                            </h3>
                        </div>
                    </div>
                </a>
            </div>

            <!-- Pending Verifications → VerifyStudent.aspx -->
            <div class="col-sm-6 col-md-3">
                <a href="VerifyStudent.aspx" class="stat-card-link">
                    <div class="card shadow-sm border-warning h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-user-check fa-3x text-warning mb-3"></i>
                            <h5 class="card-title">Pending Verifications</h5>
                            <h3>
                                <asp:Label ID="lblPendingVerifications" runat="server" Text="0"></asp:Label>
                            </h3>
                        </div>
                    </div>
                </a>
            </div>

            <!-- New Complaints → ViewComplaints.aspx -->
            <div class="col-sm-6 col-md-3">
                <a href="ViewComplaints.aspx" class="stat-card-link">
                    <div class="card shadow-sm border-danger h-100">
                        <div class="card-body text-center">
                            <i class="fas fa-exclamation-triangle fa-3x text-danger mb-3"></i>
                            <h5 class="card-title">New Complaints</h5>
                            <h3>
                                <asp:Label ID="lblNewComplaints" runat="server" Text="0"></asp:Label>
                            </h3>
                        </div>
                    </div>
                </a>
            </div>

        </div>

        <!-- ================= QUICK MENU (SAME AS SIDEBAR) ================= -->
        <div class="row mt-5">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <i class="fas fa-bars me-2"></i> Quick Menu
                    </div>
                    <div class="card-body">
                        <div class="row g-3">

                          

                            <!-- Verify Students -->
                            <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                <a href="VerifyStudent.aspx" class="quick-menu-tile">
                                    <i class="fas fa-user-check"></i>
                                    <span>Verify Students</span>
                                </a>
                            </div>

                            <!-- Add Colleges -->
                            <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                <a href="AddCollegeData.aspx" class="quick-menu-tile">
                                    <i class="fas fa-university"></i>
                                    <span>Add Colleges</span>
                                </a>
                            </div>

                            <!-- Add Course -->
                            <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                <a href="AddCourse.aspx" class="quick-menu-tile">
                                    <i class="fas fa-book"></i>
                                    <span>Add Course</span>
                                </a>
                            </div>

                            <!-- View Listings -->
                            <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                <a href="ViewListing.aspx" class="quick-menu-tile">
                                    <i class="fas fa-list-alt"></i>
                                    <span>View Listings</span>
                                </a>
                            </div>

                            <!-- Manage Student -->
                            <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                <a href="ViewUsers.aspx" class="quick-menu-tile">
                                    <i class="fas fa-users-cog"></i>
                                    <span>Manage Student</span>
                                </a>
                            </div>

                            <!-- Complaints -->
                            <div class="col-6 col-sm-4 col-md-3 col-lg-2">
                                <a href="ViewComplaints.aspx" class="quick-menu-tile">
                                    <i class="fas fa-comment-dots"></i>
                                    <span>Complaints</span>
                                </a>
                            </div>

                         
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ================= RECENT ACTIVITY ================= -->
        <div class="row mt-4">
            <div class="col-12">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        Recent Activity
                    </div>
                    <div class="card-body" style="min-height: 200px;">
                        <asp:Literal ID="litRecentActivity" runat="server" Text="<p>No recent activity to display.</p>"></asp:Literal>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>