<%@ Page Title="" Language="C#" MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true"
    CodeBehind="PurchaseReplyProductdetails.aspx.cs"
    Inherits="StudySwap.Student.PurchaseReplyProductdetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .product-img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <asp:Panel ID="pnlNotFound" runat="server" CssClass="alert alert-danger" Visible="false">
        Product not found.
    </asp:Panel>

    <asp:Panel ID="pnlProduct" runat="server" Visible="false">

        <div class="row">
            <!-- Images -->
          <!-- Images -->
<div class="col-md-6">
    <!-- Main Image -->
    <asp:Image ID="imgMain" runat="server" CssClass="product-img mb-3" />

    <!-- Thumbnails -->
    <div class="d-flex gap-2">
        <asp:ImageButton ID="imgThumb1" runat="server"
            CssClass="img-thumbnail"
            Width="100" Height="80"
            OnClick="Thumbnail_Click" />

        <asp:ImageButton ID="imgThumb2" runat="server"
            CssClass="img-thumbnail"
            Width="100" Height="80"
            OnClick="Thumbnail_Click" />

        <asp:ImageButton ID="imgThumb3" runat="server"
            CssClass="img-thumbnail"
            Width="100" Height="80"
            OnClick="Thumbnail_Click" />
    </div>
</div>


            <!-- Details -->
            <div class="col-md-6">
                <h3><asp:Label ID="lblTitle" runat="server" /></h3>

                <h4 class="text-success">
                    ₹ <asp:Label ID="lblPrice" runat="server" />
                </h4>

                <p>
                    <strong>Condition:</strong>
                    <asp:Label ID="lblCondition" runat="server" />
                </p>

                <p>
                    <strong>Posted On:</strong>
                    <asp:Label ID="lblPostedDate" runat="server" />
                </p>

                <hr />

                <p>
                    <strong>Description:</strong><br />
                    <asp:Label ID="lblDescription" runat="server" />
                </p>

                <asp:Button ID="btnBack"
                    runat="server"
                    Text="← Back to Browse"
                    CssClass="btn btn-secondary mt-3"
                    OnClick="btnBack_Click" />
            </div>
            <asp:HiddenField ID="hfListingID" runat="server" />
<asp:HiddenField ID="hfRequestID" runat="server" />

            <asp:Button ID="btnBuyNow"
    runat="server"
    Text="Buy & Pay"
    CssClass="btn btn-success me-2"
    OnClick="btnBuyNow_Click" />

<asp:Button ID="btnNotInterested"
    runat="server"
    Text="Not Interested"
    CssClass="btn btn-danger"
    OnClick="btnNotInterested_Click" />

<asp:Label ID="lblMessage"
    runat="server"
    CssClass="text-success mt-3 d-block" />
        </div>

    </asp:Panel>

</asp:Content>
