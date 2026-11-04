<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="StudySwap.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Slider Styling */
        .carousel-item img {
            width: 100%;
            max-height: 460px;
            object-fit: cover;
            border-radius: 0 0 20px 20px;
        }

        /* Action Bar */
        .hero-action-bar {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 10px 35px rgba(0,0,0,0.08);
            padding: 24px 30px;
            margin-top: -45px;
            position: relative;
            z-index: 10;
            border: 1px solid #e2e8f0;
        }

        .action-btn-primary {
            background: linear-gradient(135deg, #4f46e5, #4338ca);
            color: #fff !important;
            border: none;
            padding: 12px 28px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .action-btn-primary:hover {
            box-shadow: 0 6px 20px rgba(79,70,229,0.35);
            transform: translateY(-2px);
        }

        .action-btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #fff !important;
            border: none;
            padding: 12px 28px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
        }
        .action-btn-success:hover {
            box-shadow: 0 6px 20px rgba(16,185,129,0.35);
            transform: translateY(-2px);
        }

        .action-btn-outline {
            border: 2px solid #cbd5e1;
            color: #334155 !important;
            padding: 10px 26px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            background: #fff;
        }
        .action-btn-outline:hover {
            border-color: #64748b;
            background: #f8fafc;
            transform: translateY(-2px);
        }

        /* Feature Cards */
        .feature-card {
            background: #fff;
            border-radius: 16px;
            padding: 32px 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            transition: transform 0.2s, box-shadow 0.2s;
            border: 1px solid #f1f5f9;
            height: 100%;
        }
        .feature-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.08);
        }

        .step-circle {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4f46e5, #6366f1);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            font-weight: 700;
            margin: 0 auto 18px auto;
            box-shadow: 0 4px 14px rgba(79,70,229,0.3);
        }

        .feature-icon-box {
            width: 60px;
            height: 60px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 26px;
            margin: 0 auto 16px auto;
        }

        .badge-pill-soft {
            background: #ede9fe;
            color: #5b21b6;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <!-- ===== HERO CAROUSEL (CLEAN, NO OVERLAPPING TEXT) ===== -->
    <div id="homeSlider" class="carousel slide" data-bs-ride="carousel" data-bs-interval="3500">

        <!-- Indicators -->
        <div class="carousel-indicators">
            <button type="button" data-bs-target="#homeSlider" data-bs-slide-to="0" class="active"></button>
            <button type="button" data-bs-target="#homeSlider" data-bs-slide-to="1"></button>
            <button type="button" data-bs-target="#homeSlider" data-bs-slide-to="2"></button>
        </div>

        <!-- Slides -->
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img src="Photo/img1.png" class="d-block w-100" alt="Buy & Sell Study Materials">
            </div>
            <div class="carousel-item">
                <img src="Photo/img2.png" class="d-block w-100" alt="Exchange Academic Books">
            </div>
            <div class="carousel-item">
                <img src="Photo/img4.png" class="d-block w-100" alt="Sustainable Campus Network">
            </div>
        </div>

        <!-- Controls -->
        <button class="carousel-control-prev" type="button" data-bs-target="#homeSlider" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#homeSlider" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>

    </div>

    <!-- ===== FLOATING ACTION BAR ===== -->
    <div class="container">
        <div class="hero-action-bar">
            <div class="row align-items-center g-3 text-center text-md-start">
                <div class="col-lg-6">
                    <h4 class="fw-bold mb-1" style="color: #1e293b;">
                        <i class="bi bi-recycle text-primary me-2"></i>Campus Peer-to-Peer Academic Exchange
                    </h4>
                    <p class="text-muted mb-0" style="font-size: 14px;">
                        Save money on textbooks, instruments & calculators directly from verified college seniors.
                    </p>
                </div>
                <div class="col-lg-6 d-flex flex-wrap justify-content-center justify-content-lg-end gap-2">
                    <a href="/Student/BrowseItems.aspx" class="action-btn-primary">
                        <i class="bi bi-grid-fill"></i> Browse Items
                    </a>
                    <a href="/Register.aspx" class="action-btn-success">
                        <i class="bi bi-person-plus-fill"></i> Register
                    </a>
                    <a href="/Login.aspx" class="action-btn-outline">
                        <i class="bi bi-box-arrow-in-right"></i> Sign In
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== HOW IT WORKS SECTION ===== -->
    <div class="container my-5 py-4">
        <div class="text-center mb-5">
            <span class="badge-pill-soft">Simple 3-Step Process</span>
            <h2 class="fw-bold mt-2" style="color: #0f172a;">How StudySwap Works</h2>
            <p class="text-muted">Connecting college juniors and seniors for safe, syllabus-accurate resource sharing.</p>
        </div>

        <div class="row g-4 text-center">
            <div class="col-md-4">
                <div class="feature-card">
                    <div class="step-circle">1</div>
                    <h5 class="fw-bold" style="color: #1e293b;">Sign Up & Verify</h5>
                    <p class="text-muted mb-0" style="font-size: 14px;">
                        Register with your College Roll Number and upload your student ID card for verified campus access.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="step-circle">2</div>
                    <h5 class="fw-bold" style="color: #1e293b;">Browse or Post Gear</h5>
                    <p class="text-muted mb-0" style="font-size: 14px;">
                        Explore semester-wise textbooks, multimeters, drafters, and lab coats, or list your own items in seconds.
                    </p>
                </div>
            </div>

            <div class="col-md-4">
                <div class="feature-card">
                    <div class="step-circle">3</div>
                    <h5 class="fw-bold" style="color: #1e293b;">Chat & Swap Safely</h5>
                    <p class="text-muted mb-0" style="font-size: 14px;">
                        Connect directly with verified students via WhatsApp or exchange requests, then trade conveniently on campus.
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== KEY BENEFITS ===== -->
    <div class="bg-light py-5 my-5">
        <div class="container">
            <div class="text-center mb-5">
                <span class="badge-pill-soft" style="background: #dcfce7; color: #15803d;">Campus Features</span>
                <h2 class="fw-bold mt-2" style="color: #0f172a;">Built Exclusively for College Needs</h2>
            </div>

            <div class="row g-4">
                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon-box" style="background: #e0e7ff; color: #4338ca;">
                            <i class="bi bi-wallet2"></i>
                        </div>
                        <h5 class="fw-bold" style="color: #1e293b;">Save Up to 70%</h5>
                        <p class="text-muted mb-0" style="font-size: 14px;">
                            Avoid high bookstore retail rates by purchasing pre-owned, high-quality reference books directly from seniors.
                        </p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon-box" style="background: #dcfce7; color: #15803d;">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <h5 class="fw-bold" style="color: #1e293b;">Privacy-Protected Chat</h5>
                        <p class="text-muted mb-0" style="font-size: 14px;">
                            Student sellers have complete privacy control. Phone numbers are hidden unless the student opts in to enable WhatsApp chat.
                        </p>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="feature-card text-center">
                        <div class="feature-icon-box" style="background: #e0f2fe; color: #0369a1;">
                            <i class="bi bi-recycle"></i>
                        </div>
                        <h5 class="fw-bold" style="color: #1e293b;">Zero Waste Campus</h5>
                        <p class="text-muted mb-0" style="font-size: 14px;">
                            Pass down usable gear to incoming juniors every semester, promoting an eco-friendly campus circular economy.
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== CALL TO ACTION BANNER ===== -->
    <div class="container my-5 text-center">
        <div class="p-5 rounded-4 shadow-sm" style="background: linear-gradient(135deg, #4f46e5, #7c3aed); color: white;">
            <h2 class="fw-bold mb-3">Ready to find or sell your study gear?</h2>
            <p class="lead mb-4" style="color: #e0e7ff; font-size: 16px;">
                Join hundreds of students already trading books, instruments, and notes safely on campus.
            </p>
            <div class="d-flex justify-content-center flex-wrap gap-3">
                <a href="/Register.aspx" class="btn btn-light px-4 py-2 fw-bold text-primary shadow-sm">
                    <i class="bi bi-person-plus-fill me-1"></i> Create Student Account
                </a>
                <a href="/Login.aspx" class="btn btn-outline-light px-4 py-2 fw-bold">
                    <i class="bi bi-box-arrow-in-right me-1"></i> Sign In to Account
                </a>
            </div>
        </div>
    </div>

</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="scripts" runat="server">
</asp:Content>
