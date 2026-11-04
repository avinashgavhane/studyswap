<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="ListingDetails.aspx.cs"
    Inherits="StudySwap.Student.ListingDetails"
    MasterPageFile="~/Student/Student.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
  </asp:Content>  
    <asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
        
    <!-- Bootstrap & jQuery (if not already in master page) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <div class="container mt-4">

        <!-- BACK BUTTON -->
        <asp:Button ID="btnBack" runat="server"
            Text="← Back"
            CssClass="btn btn-outline-secondary mb-3"
            OnClick="btnBack_Click" />

        <div class="row">
            <!-- IMAGE GALLERY -->
        <div class="col-md-5">

    <!-- MAIN IMAGE -->
    <asp:Image ID="imgMain" runat="server"
        CssClass="img-fluid border rounded mb-3"
        Style="width:100%; height:380px; object-fit:cover;" />

    <!-- THUMBNAILS -->
    <div class="d-flex gap-2">
        <asp:ImageButton ID="imgThumb1" runat="server"
            CssClass="img-thumbnail"
            Width="100" Height="80"
            OnClick="Thumbnail_Click" />

        <asp:ImageButton ID="imgThumb2" runat="server"
            CssClass="img-thumbnail"
            Width="100" Height="80"
            OnClick="Thumbnail_Click"
            Visible="false" />

        <asp:ImageButton ID="imgThumb3" runat="server"
            CssClass="img-thumbnail"
            Width="100" Height="80"
            OnClick="Thumbnail_Click"
            Visible="false" />
    </div>
</div>


            <!-- LISTING DETAILS -->
            <div class="col-md-7">
                <h3 class="fw-bold">
                    <asp:Label ID="lblTitle" runat="server" />
                </h3>

                <h4 class="text-success mb-2">
                    <asp:Label ID="lblPrice" runat="server" />
                </h4>

                <p>
                    <strong>Condition:</strong>
                    <asp:Label ID="lblCondition" runat="server" />
                </p>

                <p>
                    <strong>Type:</strong>
                    <asp:Label ID="lblListingType" runat="server" />
                </p>

                <p>
                    <strong>Posted:</strong>
                    <asp:Label ID="lblPostedDate" runat="server" />
                </p>

          <p><strong>Seller Name:</strong> <asp:Label ID="lblStudentName" runat="server" /></p>
<p><strong>Email:</strong> <asp:Label ID="lblStudentEmail" runat="server" /></p>
<p><strong>Mobile:</strong> <asp:Label ID="lblStudentMobile" runat="server" /></p>
<p><strong>College:</strong> <asp:Label ID="lblStudentCollege" runat="server" /></p>
<p><strong>Department:</strong> <asp:Label ID="lblDepartment" runat="server" /></p>
<p><strong>Course:</strong> <asp:Label ID="lblCourse" runat="server" /></p>


                <hr />

                <p>
                    <asp:Label ID="lblDescription" runat="server" />
                </p>

                                <div style="display: flex; align-items: center; flex-wrap: wrap; gap: 12px; margin-top: 15px;">
                    <asp:Button ID="btnSendRequest" runat="server"
                        Text="Send Request"
                        CssClass="btn btn-primary btn-lg"
                        OnClick="btnSendRequest_Click" />

                    <asp:HyperLink ID="lnkWhatsApp" runat="server" 
                        Target="_blank" 
                        CssClass="btn-whatsapp-chat" 
                        Visible="false">
                        <i class="bi bi-whatsapp" style="font-size: 1.1rem;"></i> Chat on WhatsApp
                    </asp:HyperLink>
                </div>
            </div>
        </div>
    </div>

    <!-- REQUEST MODAL -->
   
       <style>
        .btn-whatsapp-chat {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            background: linear-gradient(135deg, #25D366, #128C7E);
            color: #ffffff !important;
            font-family: var(--font-body, 'DM Sans', sans-serif);
            font-weight: 700;
            font-size: 0.95rem;
            letter-spacing: 0.02em;
            padding: 0.9rem 1.8rem;
            border-radius: 100px;
            text-decoration: none !important;
            box-shadow: 0 4px 15px rgba(37, 211, 102, 0.3);
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            vertical-align: middle;
        }
        .btn-whatsapp-chat:hover {
            background: linear-gradient(135deg, #1ebd5a, #075E54);
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(37, 211, 102, 0.45);
            color: #ffffff !important;
        }
        /* ============================================
           PREMIUM MARKETPLACE DESIGN SYSTEM
           Bold, Editorial, Unforgettable
           ============================================ */

        :root {
            /* Color System - Deep Jewel Tones */
            --primary: #1a1a2e;
            --accent-gold: #d4af37;
            --accent-emerald: #047857;
            --accent-ruby: #dc2626;
            --surface: #ffffff;
            --surface-elevated: #f8f9fa;
            --text-primary: #1a1a2e;
            --text-secondary: #6b7280;
            --border-subtle: #e5e7eb;
            
            /* Typography */
            --font-display: 'Playfair Display', Georgia, serif;
            --font-body: 'DM Sans', -apple-system, sans-serif;
            --font-accent: 'Bebas Neue', sans-serif;
            
            /* Spacing Rhythm */
            --space-xs: 0.5rem;
            --space-sm: 1rem;
            --space-md: 1.5rem;
            --space-lg: 2.5rem;
            --space-xl: 4rem;
        }

        /* Global Resets & Base Styles */
        #ContentPlaceHolder1_btnBack,
        .container {
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) backwards;
        }

        /* ============================================
           BACK BUTTON - Minimalist Sophistication
           ============================================ */
        
        #ContentPlaceHolder1_btnBack {
            font-family: var(--font-body);
            font-weight: 500;
            font-size: 0.875rem;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            color: var(--text-primary);
            background: transparent;
            border: 1.5px solid var(--border-subtle);
            padding: 0.75rem 1.5rem;
            border-radius: 100px;
            transition: all 0.3s cubic-bezier(0.16, 1, 0.3, 1);
            position: relative;
            overflow: hidden;
        }

        #ContentPlaceHolder1_btnBack::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            background: var(--primary);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            transition: width 0.4s ease, height 0.4s ease;
            z-index: -1;
        }

        #ContentPlaceHolder1_btnBack:hover {
            color: white;
            border-color: var(--primary);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(26, 26, 46, 0.15);
        }

        #ContentPlaceHolder1_btnBack:hover::before {
            width: 300px;
            height: 300px;
        }

        /* ============================================
           IMAGE GALLERY - Museum-Grade Presentation
           ============================================ */

        .image-gallery-container {
            position: sticky;
            top: 100px;
            animation: slideInLeft 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.2s backwards;
        }

        .image-scroll-wrapper {
            max-height: 600px;
            overflow-y: auto;
            overflow-x: hidden;
            scroll-behavior: smooth;
            scroll-snap-type: y mandatory;
            padding-right: 12px;
            
            /* Custom Scrollbar */
            scrollbar-width: thin;
            scrollbar-color: var(--accent-gold) var(--surface-elevated);
        }

        .image-scroll-wrapper::-webkit-scrollbar {
            width: 4px;
        }

        .image-scroll-wrapper::-webkit-scrollbar-track {
            background: var(--surface-elevated);
            border-radius: 10px;
        }

        .image-scroll-wrapper::-webkit-scrollbar-thumb {
            background: linear-gradient(180deg, var(--accent-gold), var(--accent-emerald));
            border-radius: 10px;
        }

        /* Individual Image Cards */
        .image-scroll-item {
            scroll-snap-align: start;
            margin-bottom: 20px;
            position: relative;
            border-radius: 0;
            overflow: hidden;
            background: var(--primary);
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.25);
            transition: all 0.5s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .image-scroll-item::before {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(
                135deg,
                rgba(212, 175, 55, 0.2) 0%,
                rgba(4, 120, 87, 0.2) 100%
            );
            opacity: 0;
            transition: opacity 0.5s ease;
            z-index: 1;
            pointer-events: none;
        }

        .image-scroll-item:hover::before {
            opacity: 1;
        }

        .image-scroll-item img {
            width: 100%;
            height: 380px;
            object-fit: cover;
            display: block;
            transition: transform 0.7s cubic-bezier(0.16, 1, 0.3, 1);
            filter: contrast(1.05) saturate(1.1);
        }

        .image-scroll-item:hover {
            transform: translateX(-8px);
            box-shadow: 
                0 30px 80px rgba(0, 0, 0, 0.3),
                0 0 0 1px rgba(212, 175, 55, 0.2);
        }

        .image-scroll-item:hover img {
            transform: scale(1.15);
        }

        /* ============================================
           LISTING DETAILS - Editorial Layout
           ============================================ */

        .details-container {
            animation: slideInRight 0.8s cubic-bezier(0.16, 1, 0.3, 1) 0.3s backwards;
        }

        /* Title - Display Typography */
        .listing-title {
            font-family: var(--font-display);
            font-weight: 900;
            font-size: clamp(2rem, 5vw, 3.5rem);
            line-height: 1.1;
            color: var(--text-primary);
            margin-bottom: var(--space-md);
            letter-spacing: -0.02em;
            position: relative;
            display: inline-block;
        }

        .listing-title::after {
            content: '';
            position: absolute;
            bottom: -8px;
            left: 0;
            width: 60px;
            height: 4px;
            background: var(--accent-gold);
            animation: expandWidth 1s cubic-bezier(0.16, 1, 0.3, 1) 0.8s backwards;
        }

        /* Price - Dramatic Emphasis */
        .listing-price {
            font-family: var(--font-accent);
            font-size: 3.5rem;
            letter-spacing: 0.02em;
            background: linear-gradient(135deg, var(--accent-emerald), var(--accent-gold));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: var(--space-lg);
            display: inline-block;
            animation: shimmer 3s ease-in-out infinite;
        }

        @keyframes shimmer {
            0%, 100% { filter: brightness(1); }
            50% { filter: brightness(1.2); }
        }

        /* Info Grid */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: var(--space-md);
            margin-bottom: var(--space-lg);
            padding: var(--space-lg);
            background: linear-gradient(135deg, #f8f9fa 0%, #ffffff 100%);
            border: 1px solid var(--border-subtle);
            position: relative;
            overflow: hidden;
        }

        .info-grid::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent-gold), var(--accent-emerald));
        }

        .info-item {
            animation: fadeIn 0.6s ease backwards;
        }

        .info-item:nth-child(1) { animation-delay: 0.4s; }
        .info-item:nth-child(2) { animation-delay: 0.5s; }
        .info-item:nth-child(3) { animation-delay: 0.6s; }
        .info-item:nth-child(4) { animation-delay: 0.7s; }

        .info-label {
            font-family: var(--font-body);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            color: var(--text-secondary);
            margin-bottom: 0.25rem;
        }

        .info-value {
            font-family: var(--font-body);
            font-size: 1.125rem;
            font-weight: 500;
            color: var(--text-primary);
        }

        /* Divider */
        .divider {
            height: 1px;
            background: linear-gradient(
                90deg,
                transparent,
                var(--border-subtle) 20%,
                var(--border-subtle) 80%,
                transparent
            );
            margin: var(--space-lg) 0;
        }

        /* Description */
        .listing-description {
            font-family: var(--font-body);
            font-size: 1.0625rem;
            line-height: 1.8;
            color: var(--text-primary);
            margin-bottom: var(--space-xl);
            max-width: 65ch;
        }

        /* ============================================
           CTA BUTTON - Premium Interaction
           ============================================ */

        #ContentPlaceHolder1_btnSendRequest {
            font-family: var(--font-body);
            font-weight: 700;
            font-size: 1.125rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: white;
            background: linear-gradient(135deg, var(--primary) 0%, #2d2d44 100%);
            border: none;
            padding: 1.25rem 3.5rem;
            border-radius: 0;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
            box-shadow: 
                0 20px 40px rgba(26, 26, 46, 0.3),
                0 0 0 1px rgba(212, 175, 55, 0.2);
        }

        #ContentPlaceHolder1_btnSendRequest::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(
                90deg,
                transparent,
                rgba(255, 255, 255, 0.2),
                transparent
            );
            transition: left 0.6s ease;
        }

        #ContentPlaceHolder1_btnSendRequest:hover::before {
            left: 100%;
        }

        #ContentPlaceHolder1_btnSendRequest::after {
            content: '→';
            position: absolute;
            right: 2rem;
            top: 50%;
            transform: translateY(-50%);
            opacity: 0;
            transition: all 0.3s ease;
        }

        #ContentPlaceHolder1_btnSendRequest:hover {
            transform: translateY(-4px);
            padding-right: 4rem;
            box-shadow: 
                0 30px 60px rgba(26, 26, 46, 0.4),
                0 0 0 2px var(--accent-gold);
        }

        #ContentPlaceHolder1_btnSendRequest:hover::after {
            opacity: 1;
        }

        #ContentPlaceHolder1_btnSendRequest:active {
            transform: translateY(-2px);
        }

        /* ============================================
           ANIMATIONS
           ============================================ */

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        @keyframes expandWidth {
            from { width: 0; }
            to { width: 60px; }
        }

        /* ============================================
           RESPONSIVE DESIGN
           ============================================ */

        @media (max-width: 768px) {
            .image-gallery-container {
                position: relative;
                top: 0;
                margin-bottom: var(--space-lg);
            }

            .image-scroll-wrapper {
                max-height: none;
                display: flex;
                overflow-x: auto;
                overflow-y: hidden;
                scroll-snap-type: x mandatory;
                padding-right: 0;
                padding-bottom: 1rem;
                gap: 1rem;
            }

            .image-scroll-item {
                min-width: 85%;
                margin-bottom: 0;
                flex-shrink: 0;
            }

            .image-scroll-item img {
                height: 280px;
            }

            .listing-title {
                font-size: 2rem;
            }

            .listing-price {
                font-size: 2.5rem;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            #ContentPlaceHolder1_btnSendRequest {
                width: 100%;
                padding: 1rem 2rem;
            }
        }

        /* ============================================
           UTILITY CLASSES
           ============================================ */

        .row {
            --bs-gutter-x: 3rem;
        }

        @media (max-width: 768px) {
            .row {
                --bs-gutter-x: 1.5rem;
            }
        }
    </style>

</asp:Content>

