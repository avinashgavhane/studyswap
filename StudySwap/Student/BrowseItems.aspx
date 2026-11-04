<%@ Page Title="Browse Items"
    Language="C#"
    MasterPageFile="~/Student/Student.Master"
    AutoEventWireup="true"
    CodeBehind="~/Student/BrowseItems.aspx.cs"
    Inherits="StudySwap.Student.BrowseItems" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Archivo+Black&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
<link href="CSS/BROWSELISTING.css" rel="stylesheet" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <!-- Hero Section -->
    

    <!-- Main Container -->
    <div class="browse-container">
        
        <!-- Filter Section -->
<%--        <div class="filter-section">
            <div class="filter-header">
                <div class="filter-icon">🔍</div>
                <h2 class="filter-title">Filter & Search</h2>
            </div>
            <div class="filter-grid">
                <div class="filter-group">
                    <label>Search</label>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="filter-control" 
                        placeholder="Search by title..." style="padding-right: 1rem;"></asp:TextBox>
                </div>
                <div class="filter-group">
                    <label>Condition</label>
                    <asp:DropDownList ID="ddlCondition" runat="server" CssClass="filter-control" AutoPostBack="true">
                        <asp:ListItem Value="">All Conditions</asp:ListItem>
                        <asp:ListItem Value="New">New</asp:ListItem>
                        <asp:ListItem Value="Like New">Like New</asp:ListItem>
                        <asp:ListItem Value="Good">Good</asp:ListItem>
                        <asp:ListItem Value="Fair">Fair</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <label>Price Range</label>
                    <asp:DropDownList ID="ddlPriceRange" runat="server" CssClass="filter-control" AutoPostBack="true">
                        <asp:ListItem Value="">All Prices</asp:ListItem>
                        <asp:ListItem Value="0-500">Under ₹500</asp:ListItem>
                        <asp:ListItem Value="500-1000">₹500 - ₹1000</asp:ListItem>
                        <asp:ListItem Value="1000-2000">₹1000 - ₹2000</asp:ListItem>
                        <asp:ListItem Value="2000+">Above ₹2000</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="filter-group">
                    <label>Sort By</label>
                    <asp:DropDownList ID="ddlSortBy" runat="server" CssClass="filter-control" AutoPostBack="true">
                        <asp:ListItem Value="newest">Newest First</asp:ListItem>
                        <asp:ListItem Value="oldest">Oldest First</asp:ListItem>
                        <asp:ListItem Value="price_low">Price: Low to High</asp:ListItem>
                        <asp:ListItem Value="price_high">Price: High to Low</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
        </div>--%>

        <!-- Results Header -->
        <div class="results-header">
            <div class="results-count">
                Showing <span><asp:Label ID="lblResultCount" runat="server" Text="0"></asp:Label></span> results
            </div>
            <div class="view-toggle">
                <button class="view-btn active" title="Grid View">📊</button>
                <button class="view-btn" title="List View">📋</button>
            </div>
        </div>

        <!-- Items Grid -->
        <div class="items-grid">
            <asp:Repeater ID="rptListings" runat="server" OnItemCommand="rptListings_ItemCommand">
                <ItemTemplate>
                    <div class="item-card">
                        <!-- Image Container -->
                        <div class="card-image-wrapper">
                            <img src='<%# GetImagePath(Eval("Image1Path")) %>' 
                                 alt='<%# Eval("Title") %>' 
                                 class="card-image"
                                 onerror="this.src='https://via.placeholder.com/400x320/FF3366/ffffff?text=No+Image'" />
                            
                            <div class="price-badge"><%# Eval("SellingPrice", "{0:N0}") %></div>
                            <div class="condition-badge condition-<%# GetConditionClass(Eval("Condition").ToString()) %>">
                                <%# Eval("Condition") %>
                            </div>
                            <div class="favorite-btn" title="Add to Favorites">❤️</div>

                            <!-- Overlay -->
                            <div class="card-overlay">
                                <div class="overlay-content">
                                    <div class="overlay-title"><%# Eval("Title") %></div>
                                    <div class="overlay-date">📅 Posted: <%# GetRelativeDate(Eval("PostedDate")) %></div>
                                </div>
                            </div>
                        </div>

                        <!-- Card Content -->
                        <div class="card-content">
                            <h3 class="card-title"><%# Eval("Title") %></h3>
                            
                            <div class="card-meta">
                                <div class="meta-item">
                                    <span class="meta-icon">📅</span>
                                    <span><%# GetFormattedDate(Eval("PostedDate")) %></span>
                                </div>
                                <div class="meta-item">
                                    <span class="meta-icon">✨</span>
                                    <span><%# Eval("Condition") %></span>
                                </div>
                            </div>
                        </div>

                        <!-- Card Footer -->
                        <div class="card-footer">
                            <asp:LinkButton ID="btnViewDetails" runat="server" 
                                CssClass="view-details-btn"
                                CommandName="ViewDetails" 
                                CommandArgument='<%# Eval("ListingID") %>'>
                                👁️ View Details
                            </asp:LinkButton>
                            <div class="quick-actions">
                                <button class="action-icon-btn" title="Contact">💬</button>
                                <button class="action-icon-btn" title="Share">🔗</button>
                                
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Empty State -->
        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="empty-state">
            <div class="empty-icon">📦</div>
            <h2 class="empty-title">No Listings Found</h2>
            <p class="empty-text">Try adjusting your filters or check back later for new items</p>
        </asp:Panel>

    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loader"></div>
    </div>

    <!-- Request Modal -->

    <script>
        // View Toggle
        const viewBtns = document.querySelectorAll('.view-btn');
        viewBtns.forEach(btn => {
            btn.addEventListener('click', function () {
                viewBtns.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
            });
        });

        // Show loading on postback
        function showLoading() {
            document.getElementById('loadingOverlay').classList.add('show');
        }

        // Smooth scroll reveal (optional enhancement)
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach((entry) => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0) scale(1)';
                }
            });
        }, observerOptions);

        document.addEventListener('DOMContentLoaded', () => {
            const cards = document.querySelectorAll('.item-card');
            cards.forEach(card => observer.observe(card));
        });
    </script>
</asp:Content>
