<%@ Page Title="Request an Item" Language="C#" MasterPageFile="~/Student/Student.Master" AutoEventWireup="true" CodeBehind="PurchaseListing.aspx.cs" Inherits="StudySwap.Student.PurchaseListing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- FontAwesome CDN for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background: #f0f4f8;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .purchase-card {
            background: #ffffff;
            border-radius: 18px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.12);
            padding: 40px 45px;
            max-width: 700px;
            margin: 60px auto 80px auto;
            animation: fadeInUp 0.7s ease forwards;
            transition: box-shadow 0.3s ease;
        }
        .purchase-card:hover {
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.18);
        }

        .purchase-title {
            font-size: 30px;
            font-weight: 800;
            color: #1f2937;
            letter-spacing: 0.04em;
        }

        .purchase-subtitle {
            color: #6b7280;
            font-size: 16px;
            margin-bottom: 35px;
            font-weight: 500;
        }

        label.form-label {
            font-weight: 700;
            font-size: 14px;
            color: #374151;
            margin-bottom: 8px;
            display: inline-block;
            user-select: none;
        }

        .form-control, .form-select {
            width: 100%;
            border-radius: 12px;
            border: 1.8px solid #d1d5db;
            padding: 14px 18px;
            font-size: 16px;
            color: #111827;
            transition: border-color 0.25s ease;
            box-sizing: border-box;
            font-weight: 500;
            outline-offset: 2px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 8px rgba(37, 99, 235, 0.4);
            outline: none;
        }

        .btn-request {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            border: none;
            border-radius: 35px;
            padding: 14px 38px;
            font-size: 18px;
            font-weight: 700;
            color: white;
            cursor: pointer;
            letter-spacing: 0.04em;
            box-shadow: 0 6px 14px rgba(37, 99, 235, 0.5);
            transition: all 0.3s ease;
            user-select: none;
        }

        .btn-request:hover, .btn-request:focus {
            background: linear-gradient(135deg, #1e40af, #1e3a8a);
            box-shadow: 0 10px 28px rgba(29, 58, 138, 0.7);
            transform: translateY(-3px);
            outline: none;
        }

        .btn-request:active {
            transform: translateY(-1px);
            box-shadow: 0 4px 10px rgba(29, 58, 138, 0.6);
        }

        @keyframes fadeInUp {
            0% {
                opacity: 0;
                transform: translateY(40px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Responsive for mobile */
        @media (max-width: 768px) {
            .purchase-card {
                margin: 30px 20px 50px 20px;
                padding: 30px 25px;
                max-width: 100%;
            }

            .purchase-title {
                font-size: 24px;
            }

            .btn-request {
                width: 100%;
                padding: 11px 0;
            }
              btn logout-btn {
                width: 100%;
                padding: 11px 0;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="purchase-card" role="main" aria-label="Request an Item Form">

        <div class="text-center mb-4" aria-hidden="true">
            <i class="fas fa-shopping-basket fa-4x text-primary mb-3"></i>
            <h1 class="purchase-title">Request an Item</h1>
            <p class="purchase-subtitle">
                Can’t find what you need? Let other students help you out.
            </p>
        </div>

        <!-- Item Name -->
        <div class="mb-4">
            <label for="txtItemName" class="form-label">
                <i class="fas fa-box-open me-2"></i> Item Name
            </label>
            <asp:TextBox ID="txtItemName" runat="server" CssClass="form-control" Placeholder="Eg: Engineering Mathematics Book" />
        </div>

        <!-- Category -->
        <div class="mb-4">
            <label for="ddlCategory" class="form-label">
                <i class="fas fa-tags me-2"></i> Category
            </label>
            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select" />
        </div>

        <!-- Description -->
        <div class="mb-5">
            <label for="txtDescription" class="form-label">
                <i class="fas fa-align-left me-2"></i> Description
            </label>
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control"
                Placeholder="Describe the item, condition, preferred price, etc." />
        </div>

        <!-- Submit Button -->
        <div class="text-center">
            <asp:Button ID="btnSubmitRequest" runat="server" Text="Send Purchase Request" CssClass="btn-request"
                OnClick="btnSubmitRequest_Click" />
        </div>
            <div class="text-center">
            <asp:Button ID="btnview" runat="server" CssClass="btn logout-btn"  Text="View Request" 
                OnClick="btnview_Click" />
        </div>
    </div>
</asp:Content>
