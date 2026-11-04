<%@ Page Title="My Listings" Language="C#" MasterPageFile="~/Student/Student.Master" 
    AutoEventWireup="true" CodeBehind="MyListing.aspx.cs" Inherits="StudySwap.Student.MyListing" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .listings-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 2rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }

        .header-section {
            text-align: center;
            margin-bottom: 3rem;
            color: white;
        }

        .header-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
        }

        .header-section p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        .listings-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            margin-bottom: 2rem;
        }

        @media (max-width: 1200px) {
            .listings-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .listings-grid {
                grid-template-columns: 1fr;
            }
        }

        .listing-card {
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }

        .listing-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }

        .card-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            position: relative;
        }

        .listing-id {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255,255,255,0.2);
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .card-title {
            font-size: 1.4rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            padding-right: 3rem;
        }

        .card-category {
            font-size: 0.9rem;
            opacity: 0.9;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #555;
            font-size: 0.9rem;
        }

        .info-value {
            font-weight: 500;
            color: #333;
            font-size: 0.95rem;
        }
        .request-alert.alert-success {
    background: linear-gradient(135deg, #22c55e, #16a34a);
}

.request-alert.alert-danger {
    background: linear-gradient(135deg, #ef4444, #b91c1c);
}

        .price-badge {
            background: linear-gradient(135deg, #4caf50 0%, #45a049 100%);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 25px;
            font-size: 1.1rem;
            font-weight: 700;
        }

        .status-badge {
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-sold {
            background: #f8d7da;
            color: #721c24;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .negotiable-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 0.3rem 0.8rem;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .card-actions {
            padding: 1rem 1.5rem;
            background: #f8f9fa;
            display: flex;
            gap: 1rem;
        }

        .btn-edit {
            flex: 1;
            padding: 0.8rem 1.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .btn-edit:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .empty-state h2 {
            color: #667eea;
            font-size: 2rem;
            margin-bottom: 1rem;
        }

        .empty-state p {
            color: #666;
            font-size: 1.1rem;
        }

        /* Modal Overlay */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.7);
            z-index: 1000;
            overflow-y: auto;
            padding: 2rem;
        }

        .modal-overlay.active {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .modal-content {
            background: white;
            border-radius: 20px;
            max-width: 700px;
            width: 100%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: slideIn 0.3s ease;
            max-height: 90vh;
            overflow-y: auto;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(-50px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 20px 20px 0 0;
            position: relative;
        }

        .modal-header h2 {
            font-size: 1.8rem;
            font-weight: 700;
        }

        .btn-close {
            position: absolute;
            top: 1.5rem;
            right: 1.5rem;
            background: rgba(255,255,255,0.2);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            font-size: 1.5rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .btn-close:hover {
            background: rgba(255,255,255,0.3);
            transform: rotate(90deg);
        }

        .modal-body {
            padding: 2rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.5rem;
            font-size: 0.95rem;
        }

        .form-control {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .checkbox-group input[type="checkbox"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }

        .modal-actions {
            padding: 1.5rem 2rem;
            background: #f8f9fa;
            border-radius: 0 0 20px 20px;
            display: flex;
            gap: 1rem;
        }

        .btn-update {
            flex: 1;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #4caf50 0%, #45a049 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
        }

        .btn-update:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
        }

        .btn-delete {
            flex: 1;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
        }

        .btn-delete:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.4);
        }

        .btn-cancel {
            padding: 1rem 2rem;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 10px;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-cancel:hover {
            background: #5a6268;
        }
        /* REQUEST ALERT CARD */
.request-alert {
    position: relative;
    margin-bottom: 2rem;
    padding: 1.6rem 2rem;
    border-radius: 18px;
    background: linear-gradient(135deg, #6366f1, #8b5cf6);
    color: #fff;
    box-shadow: 0 20px 50px rgba(99,102,241,.45);
    animation: slideInGlow .8s ease-out forwards;
    overflow: hidden;
}

/* Glow effect */
.request-alert::before {
    content: "";
    position: absolute;
    inset: 0;
    background: linear-gradient(120deg, transparent, rgba(255,255,255,.35), transparent);
    animation: shimmer 2.5s infinite;
}

/* TEXT */
.request-text strong {
    font-size: 1.25rem;
    letter-spacing: .5px;
}

.request-text {
    z-index: 2;
    max-width: 75%;
}

/* BUTTON */
.btn-view-request {
    z-index: 2;
    padding: .75rem 1.4rem;
    border-radius: 999px;
    border: none;
    background: #fff;
    color: #4f46e5;
    font-weight: 800;
    cursor: pointer;
    transition: .35s;
}

.btn-view-request:hover {
    transform: scale(1.1);
    background: #e0e7ff;
    box-shadow: 0 12px 30px rgba(255,255,255,.6);
}

/* SLIDE IN */
@keyframes slideInGlow {
    from {
        opacity: 0;
        transform: translateY(-25px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* SHIMMER */
@keyframes shimmer {
    0% { transform: translateX(-100%); }
    100% { transform: translateX(100%); }
}
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="listings-container">
        <div class="header-section">
            <h1>📚 My Listings</h1>
            <p>Manage all your study materials in one place</p>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>
    <div id="requestAlert" runat="server"
         class="request-alert d-flex justify-content-between align-items-center"
         visible="false">

        <div class="request-text">
            🔔 <strong>New Request Received!</strong><br />
            <asp:Label ID="lblRequestInfo" runat="server"></asp:Label>
        </div>

        <asp:Button ID="btnViewRequest"
            runat="server"
            Text="View Request"
            CssClass="btn-view-request"
            OnClick="btnViewRequest_Click" />
    </div>

        <div class="listings-grid">
            <asp:Repeater ID="rptListings" runat="server" OnItemCommand="rptListings_ItemCommand">
                <ItemTemplate>
                    <div class="listing-card">
                        <div class="card-header">
                            <span class="listing-id">#<%# Eval("ListingID") %></span>
                            <h3 class="card-title"><%# Eval("Title") %></h3>
                            <div class="card-category">
                                <span>📖</span>
                                <span><%# Eval("CategoryName") %> - <%# Eval("CourseName") %></span>
                            </div>
                        </div>
                        
                        <div class="card-body">
                            <div class="info-row">
                                <span class="info-label">Condition:</span>
                                <span class="info-value"><%# Eval("Condition") %></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Type:</span>
                                <span class="info-value"><%# Eval("ListingType") %></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Price:</span>
                                <span class="price-badge">₹<%# Eval("SellingPrice", "{0:N2}") %></span>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Negotiable:</span>
                                <%# Convert.ToBoolean(Eval("IsPriceNegotiable")) ? 
                                    "<span class='negotiable-badge'>✓ Yes</span>" : 
                                    "<span class='info-value'>No</span>" %>
                            </div>
                            <div class="info-row">
                                <span class="info-label">Status:</span>
                                <span class='status-badge <%# GetStatusClass(Eval("Status").ToString()) %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </div>
                        </div>
                        
                        <div class="card-actions">
                            <asp:Button ID="btnEdit" runat="server" 
                                Text="✏️ Edit" 
                                CssClass="btn-edit"
                                CommandName="Edit"
                                CommandArgument='<%# Eval("ListingID") %>' />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty-state" Visible="false">
            <h2>📭 No Listings Yet</h2>
            <p>Start by creating your first listing to share your study materials!</p>
        </asp:Panel>
    </div>

    <!-- Edit Modal -->
    <div id="editModal" class="modal-overlay">
        <div class="modal-content">
            <div class="modal-header">
                <h2>✏️ Edit Listing</h2>
                <button type="button" class="btn-close" onclick="closeModal()">&times;</button>
            </div>
            
            <div class="modal-body">
                <asp:HiddenField ID="hfEditListingID" runat="server" />
                
                <div class="form-group">
                    <label class="form-label">Title</label>
                    <asp:TextBox ID="txtEditTitle" runat="server" CssClass="form-control" />
                </div>
                
                <div class="form-group">
                    <label class="form-label">Condition</label>
                    <asp:DropDownList ID="ddlEditCondition" runat="server" CssClass="form-control">
                        <asp:ListItem>New</asp:ListItem>
                        <asp:ListItem>Like New</asp:ListItem>
                        <asp:ListItem>Good</asp:ListItem>
                        <asp:ListItem>Fair</asp:ListItem>
                        <asp:ListItem>Poor</asp:ListItem>
                    </asp:DropDownList>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Listing Type</label>
                    <asp:DropDownList ID="ddlEditListingType" runat="server" CssClass="form-control">
                        <asp:ListItem>Sale</asp:ListItem>
                        <asp:ListItem>Exchange</asp:ListItem>
                        <asp:ListItem>Both</asp:ListItem>
                    </asp:DropDownList>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Selling Price (₹)</label>
                    <asp:TextBox ID="txtEditPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01" />
                </div>
                
                <div class="form-group">
                    <div class="checkbox-group">
                        <asp:CheckBox ID="chkEditNegotiable" runat="server" />
                        <label class="form-label" style="margin-bottom: 0;">Price is Negotiable</label>
                    </div>
                </div>
            </div>
            
            <div class="modal-actions">
                <asp:Button ID="btnUpdate" runat="server" Text="💾 Update" CssClass="btn-update" OnClick="btnUpdate_Click" />
                <asp:Button ID="btnDelete" runat="server" Text="🗑️ Delete" CssClass="btn-delete" OnClick="btnDelete_Click" OnClientClick="return confirm('Are you sure you want to delete this listing?');" />
                <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openModal() {
            document.getElementById('editModal').classList.add('active');
            document.body.style.overflow = 'hidden';
        }

        function closeModal() {
            document.getElementById('editModal').classList.remove('active');
            document.body.style.overflow = 'auto';
        }

        // Check if modal should be open on page load
        window.onload = function() {
            var shouldOpenModal = document.getElementById('<%= hfEditListingID.ClientID %>').value;
            if (shouldOpenModal) {
                openModal();
            }
        }
    </script>
</asp:Content>