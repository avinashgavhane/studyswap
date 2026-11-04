<%@ Page Title="Manage Listings" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ViewListing.aspx.cs" Inherits="StudySwap.Admin.ViewListing" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Manage Listings
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="head" runat="server">
    <style>
        .page-wrap { max-width: 1500px; margin: 25px auto; padding: 0 20px; }
        .page-title { font-size: 22px; font-weight: 700; margin: 0 0 18px 0; color: #222; }

        /* ---- Filter bar ---- */
        .filter-bar {
            background: #fff; border: 1px solid #e3e3e3; border-radius: 10px;
            padding: 14px 18px; margin-bottom: 18px;
            display: flex; flex-wrap: wrap; gap: 12px; align-items: end;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .filter-bar .f { display: flex; flex-direction: column; gap: 4px; }
        .filter-bar label { font-size: 12px; font-weight: 600; color: #555; }
        .filter-bar input[type=text], .filter-bar select {
            padding: 7px 10px; border: 1px solid #ccc; border-radius: 5px;
            font-size: 13px; min-width: 150px;
        }
        .filter-bar .btn {
            padding: 8px 16px; background: #0078d4; color: #fff; border: none;
            border-radius: 5px; cursor: pointer; font-weight: 600; font-size: 13px;
        }
        .filter-bar .btn:hover { background: #005a9e; }
        .filter-bar .btn-gray { background: #888; }
        .filter-bar .btn-gray:hover { background: #666; }

        /* ---- Card / Grid ---- */
        .card {
            background: #fff; border: 1px solid #e3e3e3; border-radius: 10px;
            padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        .card h2 {
            margin: 0 0 16px 0; font-size: 17px; color: #0078d4;
            border-bottom: 2px solid #f0f0f0; padding-bottom: 8px;
        }
        .msg { display: block; margin: 10px 0 14px 0; font-weight: 600;
               font-size: 13px; padding: 8px 10px; border-radius: 5px; background: #f6f6f6; }
        .msg:empty { display: none; }

        .grid-wrap { overflow-x: auto; }
        .grid table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .grid th, .grid td { border: 1px solid #e1e1e1; padding: 8px 10px;
                             text-align: left; vertical-align: middle; }
        .grid th { background: #f5f7fa; color: #333; font-weight: 700; white-space: nowrap; }
        .grid tr:nth-child(even) td { background: #fafbfc; }
        .grid tr:hover td { background: #eef6fd; }
        .grid a { color: #0078d4; text-decoration: none; font-weight: 600; }
        .grid a:hover { text-decoration: underline; }
        .grid a.delete { color: #d32f2f; }

        .thumb {
            width: 50px; height: 50px; border-radius: 6px; object-fit: cover;
            border: 1px solid #e1e1e1; background: #f3f4f6;
        }
        .price { font-weight: 700; color: #166534; }

        .badge {
            display: inline-block; padding: 3px 9px; border-radius: 12px;
            font-size: 11px; font-weight: 700; text-transform: uppercase;
        }
        .badge-active   { background: #dcfce7; color: #166534; }
        .badge-pending  { background: #fef3c7; color: #92400e; }
        .badge-sold     { background: #dbeafe; color: #1e40af; }
        .badge-removed  { background: #fee2e2; color: #991b1b; }
        .badge-draft    { background: #f3f4f6; color: #4b5563; }

        /* ---- Modal ---- */
        .modal-bg {
            display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5);
            z-index: 1000; align-items: center; justify-content: center;
        }
        .modal-bg.show { display: flex; }
        .modal {
            background: #fff; border-radius: 10px; padding: 24px;
            width: 720px; max-width: 94vw; max-height: 90vh; overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.25);
        }
        .modal h3 { margin: 0 0 18px 0; font-size: 18px; color: #0078d4;
                    border-bottom: 2px solid #f0f0f0; padding-bottom: 10px; }
        .modal .form-row { margin-bottom: 12px; }
        .modal .form-row label {
            display: block; font-weight: 600; font-size: 13px; margin-bottom: 4px; color: #333;
        }
        .modal .form-row input[type=text],
        .modal .form-row input[type=number],
        .modal .form-row select,
        .modal .form-row textarea {
            width: 100%; padding: 8px 10px; border: 1px solid #ccc; border-radius: 5px;
            font-size: 14px; box-sizing: border-box; font-family: inherit;
        }
        .modal .form-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 12px;
        }
        .modal .imgs { display: flex; gap: 12px; margin-bottom: 12px; }
        .modal .imgs img {
            width: 100px; height: 100px; object-fit: cover;
            border-radius: 6px; border: 1px solid #ddd; background: #f3f4f6;
        }
        .modal .btn-row { margin-top: 18px; text-align: right; }
        .modal .btn {
            padding: 9px 20px; margin-left: 8px; border: none; border-radius: 5px;
            cursor: pointer; font-size: 14px; font-weight: 600;
        }
        .modal .btn-save  { background: #0078d4; color: #fff; }
        .modal .btn-save:hover  { background: #005a9e; }
        .modal .btn-close { background: #888; color: #fff; }
        .modal .btn-close:hover { background: #666; }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

<div class="page-wrap">
    <h1 class="page-title">Manage Listings</h1>

    <!-- ============ FILTER BAR ============ -->
    <div class="filter-bar">
        <div class="f">
            <label>Search</label>
            <asp:TextBox ID="txtSearch" runat="server" placeholder="Title / description..." />
        </div>
        <div class="f">
            <label>Category</label>
            <asp:DropDownList ID="ddlCategoryFilter" runat="server" />
        </div>
        <div class="f">
            <label>Status</label>
            <asp:DropDownList ID="ddlStatusFilter" runat="server">
                <asp:ListItem Text="All Status" Value="" />
                <asp:ListItem Text="Active"     Value="Active" />
                <asp:ListItem Text="Pending"    Value="Pending" />
                <asp:ListItem Text="Sold"       Value="Sold" />
                <asp:ListItem Text="Removed"    Value="Removed" />
                <asp:ListItem Text="Draft"      Value="Draft" />
            </asp:DropDownList>
        </div>
        <div class="f">
            <label>Type</label>
            <asp:DropDownList ID="ddlTypeFilter" runat="server">
                <asp:ListItem Text="All Types" Value="" />
                <asp:ListItem Text="Sell"      Value="Sell" />
                <asp:ListItem Text="Rent"      Value="Rent" />
                <asp:ListItem Text="Exchange"  Value="Exchange" />
                <asp:ListItem Text="Donate"    Value="Donate" />
            </asp:DropDownList>
        </div>
        <div class="f">
            <label>&nbsp;</label>
            <asp:Button ID="btnFilter" runat="server" Text="Apply" CssClass="btn" OnClick="btnFilter_Click" />
        </div>
        <div class="f">
            <label>&nbsp;</label>
            <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-gray"
                OnClick="btnReset_Click" CausesValidation="false" />
        </div>
    </div>

    <!-- ============ GRID ============ -->
    <div class="card">
        <h2>Listing List</h2>

        <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

        <div class="grid-wrap grid">
            <asp:GridView ID="gvListings" runat="server" AutoGenerateColumns="False"
                DataKeyNames="ListingID" AllowPaging="True" PageSize="10"
                GridLines="None"
                OnPageIndexChanging="gvListings_PageIndexChanging"
               
                PagerStyle-HorizontalAlign="Center">
                <Columns>
                    <asp:TemplateField HeaderText="Image">
                        <ItemTemplate>
                            <asp:Image ID="imgThumb" runat="server" CssClass="thumb"
                                ImageUrl='<%# ResolveUrl(string.IsNullOrEmpty(Convert.ToString(Eval("Image1Path")))
                                            ? "~/Uploads/Listings/default.png"
                                            : Eval("Image1Path").ToString()) %>'
                                AlternateText="Listing image" />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="ListingID"     HeaderText="ID" />
                    <asp:BoundField DataField="Title"         HeaderText="Title" />
                    <asp:BoundField DataField="SellerName"    HeaderText="Seller" />
                    <asp:BoundField DataField="CategoryName"  HeaderText="Category" />
                    <asp:BoundField DataField="CourseName"    HeaderText="Course" />
                    <asp:BoundField DataField="Condition"     HeaderText="Condition" />
                    <asp:BoundField DataField="ListingType"   HeaderText="Type" />

                    <asp:TemplateField HeaderText="Price">
                        <ItemTemplate>
                            <span class="price">
                                <%# Eval("SellingPrice") == DBNull.Value 
                                        ? "—" 
                                        : "₹" + Convert.ToDecimal(Eval("SellingPrice")).ToString("N0") %>
                            </span>
                            <%# Convert.ToBoolean(Eval("IsPriceNegotiable")) ? " <small>(nego)</small>" : "" %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='<%# GetStatusBadgeClass(Eval("Status")) %>'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:BoundField DataField="ViewsCount" HeaderText="Views" />
                    <asp:BoundField DataField="PostedDate" HeaderText="Posted"
                        DataFormatString="{0:yyyy-MM-dd}" />

                
                </Columns>
                <EmptyDataTemplate>
                    <p style="padding:20px;text-align:center;color:#888;">No listings match your filter.</p>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>
</div>

<!-- ============ EDIT MODAL ============ -->
<div id="editModal" class="modal-bg" runat="server" clientidmode="Static">
    <div class="modal">
        <h3>Edit Listing</h3>

        <asp:HiddenField ID="hfEditListingID" runat="server" Value="0" />

        <div class="imgs">
            <asp:Image ID="imgPrev1" runat="server" AlternateText="Image 1" />
            <asp:Image ID="imgPrev2" runat="server" AlternateText="Image 2" />
            <asp:Image ID="imgPrev3" runat="server" AlternateText="Image 3" />
        </div>

        <div class="form-grid">
            <div class="form-row">
                <label>Title</label>
                <asp:TextBox ID="txtEditTitle" runat="server" MaxLength="200" />
            </div>
            <div class="form-row">
                <label>Seller</label>
                <asp:TextBox ID="txtEditSeller" runat="server" ReadOnly="true" BackColor="#f3f4f6" />
            </div>
            <div class="form-row">
                <label>Category</label>
                <asp:DropDownList ID="ddlEditCategory" runat="server" />
            </div>
            <div class="form-row">
                <label>Course</label>
                <asp:DropDownList ID="ddlEditCourse" runat="server" />
            </div>
            <div class="form-row">
                <label>Condition</label>
                <asp:DropDownList ID="ddlEditCondition" runat="server">
                    <asp:ListItem Text="New"      Value="New" />
                    <asp:ListItem Text="Like New" Value="Like New" />
                    <asp:ListItem Text="Good"     Value="Good" />
                    <asp:ListItem Text="Fair"     Value="Fair" />
                    <asp:ListItem Text="Poor"     Value="Poor" />
                </asp:DropDownList>
            </div>
            <div class="form-row">
                <label>Listing Type</label>
                <asp:DropDownList ID="ddlEditType" runat="server">
                    <asp:ListItem Text="Sell"     Value="Sell" />
                    <asp:ListItem Text="Rent"     Value="Rent" />
                    <asp:ListItem Text="Exchange" Value="Exchange" />
                    <asp:ListItem Text="Donate"   Value="Donate" />
                </asp:DropDownList>
            </div>
            <div class="form-row">
                <label>Selling Price (₹)</label>
                <asp:TextBox ID="txtEditPrice" runat="server" TextMode="Number" step="0.01" />
            </div>
            <div class="form-row">
                <label>Price Negotiable</label>
                <asp:CheckBox ID="chkEditNegotiable" runat="server" Text=" Yes" />
            </div>
            <div class="form-row">
                <label>Status</label>
                <asp:DropDownList ID="ddlEditStatus" runat="server">
                    <asp:ListItem Text="Active"  Value="Active" />
                    <asp:ListItem Text="Pending" Value="Pending" />
                    <asp:ListItem Text="Sold"    Value="Sold" />
                    <asp:ListItem Text="Removed" Value="Removed" />
                    <asp:ListItem Text="Draft"   Value="Draft" />
                </asp:DropDownList>
            </div>
            <div class="form-row">
                <label>Views</label>
                <asp:TextBox ID="txtEditViews" runat="server" TextMode="Number" ReadOnly="true" BackColor="#f3f4f6" />
            </div>
        </div>

        <div class="form-row">
            <label>Description</label>
            <asp:TextBox ID="txtEditDescription" runat="server" TextMode="MultiLine" Rows="4" MaxLength="2000" />
        </div>

       
    </div>
</div>

<script>
    function openEditModal()  { document.getElementById('editModal').classList.add('show'); }
    function closeEditModal() { document.getElementById('editModal').classList.remove('show'); }
</script>

</asp:Content>