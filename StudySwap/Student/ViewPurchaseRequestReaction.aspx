<%@ Page Title="My Purchase Requests" Language="C#" 
    MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true" 
    CodeBehind="ViewPurchaseRequestReaction.aspx.cs" 
    Inherits="StudySwap.Student.ViewPurchaseRequestReaction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Container card for each request */
        .request-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 12px 35px rgba(0,0,0,0.12);
            padding: 32px 30px;
            margin-bottom: 25px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .request-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.16);
        }

        /* Titles & text */
        h3, h4 {
            color: #1f2937;
            font-weight: 700;
        }

        p {
            color: #4b5563;
            font-size: 15px;
            margin-bottom: 15px;
        }

        /* Status badge */
        .status-badge {
            font-weight: 700;
            padding: 8px 16px;
            border-radius: 22px;
            color: white;
            font-size: 13px;
            user-select: none;
            display: inline-block;
            margin-bottom: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .status-open { background-color: #0ea5e9; } /* Sky-500 */
        .status-closed { background-color: #22c55e; } /* Green-500 */

        /* Buttons */
        .btn-view-replies, .btn-warning, .btn-danger, .btn-success, .btn-secondary {
            padding: 11px 28px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 14px;
            transition: all 0.3s ease;
            cursor: pointer;
            border: none;
            user-select: none;
            margin-right: 10px;
            margin-top: 10px;
            display: inline-block;
        }

        .btn-view-replies {
            background: linear-gradient(135deg, #3b82f6, #1e40af);
            color: white;
            box-shadow: 0 6px 16px rgba(59,130,246,0.5);
        }
        .btn-view-replies:hover {
            background: linear-gradient(135deg, #1e3a8a, #1e40af);
            box-shadow: 0 8px 22px rgba(30,58,138,0.7);
            transform: translateY(-2px);
        }

        .btn-warning {
            background: linear-gradient(135deg, #fbbf24, #b45309);
            color: white;
            box-shadow: 0 6px 16px rgba(251,191,36,0.5);
        }
        .btn-warning:hover {
            background: linear-gradient(135deg, #92400e, #78350f);
            box-shadow: 0 8px 22px rgba(146,64,14,0.7);
            transform: translateY(-2px);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #b91c1c);
            color: white;
            box-shadow: 0 6px 16px rgba(239,68,68,0.5);
        }
        .btn-danger:hover {
            background: linear-gradient(135deg, #7f1d1d, #b91c1c);
            box-shadow: 0 8px 22px rgba(185,28,28,0.7);
            transform: translateY(-2px);
        }

        .btn-success {
            background: linear-gradient(135deg, #22c55e, #15803d);
            color: white;
            box-shadow: 0 6px 16px rgba(34,197,94,0.5);
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #166534, #15803d);
            box-shadow: 0 8px 22px rgba(21,128,61,0.7);
            transform: translateY(-2px);
        }

        .btn-secondary {
            background: #6b7280;
            color: white;
            box-shadow: 0 6px 16px rgba(107,114,128,0.5);
        }
        .btn-secondary:hover {
            background: #4b5563;
            box-shadow: 0 8px 22px rgba(75,85,99,0.7);
            transform: translateY(-2px);
        }

        /* Edit mode controls */
        .form-control, .form-select {
            width: 100%;
            padding: 12px 15px;
            font-size: 15px;
            margin-bottom: 14px;
            border-radius: 12px;
            border: 1.8px solid #d1d5db;
            box-sizing: border-box;
            font-weight: 600;
            color: #111827;
            transition: border-color 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 8px rgba(37, 99, 235, 0.4);
            outline: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <h3 class="mb-4" style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">My Purchase Requests</h3>

    <asp:Repeater ID="rptRequests" runat="server" OnItemCommand="rptRequests_ItemCommand" OnItemDataBound="rptRequests_ItemDataBound">
        <ItemTemplate>
            <asp:Panel ID="pnlDisplay" runat="server" Visible='<%# !IsEditing(Container) %>'>
                <div class="request-card" role="region" aria-label="Purchase Request">
                    <h4><%# Eval("ItemName") %></h4>
                    <p><%# Eval("Description") %></p>

                    <span class="status-badge 
                        <%# Eval("Status").ToString().ToLower() == "open" ? "status-open" : "status-closed" %>">
                        <%# Eval("Status") %>
                    </span>

                    <asp:Button ID="btnViewReplies" runat="server" Text="View Replies"
                        CommandName="ViewReplies" CommandArgument='<%# Eval("PurchaseRequestID") %>'
                        CssClass="btn-view-replies" />

                    <asp:Button ID="btnUpdate" runat="server" Text="Update"
                        CommandName="EditRequest" CommandArgument='<%# Eval("PurchaseRequestID") %>'
                        CssClass="btn-warning" />

                    <asp:Button ID="btnDelete" runat="server" Text="Delete"
                        CommandName="DeleteRequest" CommandArgument='<%# Eval("PurchaseRequestID") %>'
                        CssClass="btn-danger"
                        OnClientClick="return confirm('Are you sure you want to delete this request?');" />
                </div>
            </asp:Panel>

            <asp:Panel ID="pnlEdit" runat="server" Visible='<%# IsEditing(Container) %>' CssClass="request-card" role="form" aria-label="Edit Purchase Request">
                <asp:TextBox ID="txtItemNameEdit" runat="server" Text='<%# Eval("ItemName") %>' CssClass="form-control" />
                <asp:TextBox ID="txtDescriptionEdit" runat="server" Text='<%# Eval("Description") %>' TextMode="MultiLine" Rows="3" CssClass="form-control" />
                <asp:DropDownList ID="ddlStatusEdit" runat="server" CssClass="form-select">
                    <asp:ListItem Value="Active">Active</asp:ListItem>
                    <asp:ListItem Value="Deactive">Deactive</asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnSave" runat="server" Text="Save" CommandName="SaveRequest" CommandArgument='<%# Eval("PurchaseRequestID") %>' CssClass="btn-success" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CommandName="CancelEdit" CssClass="btn-secondary" />
            </asp:Panel>
        </ItemTemplate>
    </asp:Repeater>

    <asp:Label ID="lblNoRequests" runat="server" Text="You have not made any purchase requests yet."
        Visible="false" CssClass="text-muted" style="font-style: italic; font-size: 16px;"></asp:Label>

</asp:Content>
