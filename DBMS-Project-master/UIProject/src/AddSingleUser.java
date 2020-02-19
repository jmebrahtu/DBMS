import java.sql.*;
import com.microsoft.sqlserver.jdbc.*;

import javafx.scene.control.Button;
import javafx.stage.FileChooser;
import net.proteanit.sql.DbUtils;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JButton;
import javax.swing.JFileChooser;

import java.awt.BorderLayout;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.IOException;
import java.awt.event.ActionEvent;
import javax.swing.SwingConstants;

import javax.swing.JTextField;
import java.awt.Color;
import java.awt.GridLayout;
import javax.swing.JLabel;
import javax.swing.JTable;
import javax.swing.JScrollPane;

public class AddSingleUser {

	private JFrame frame;
	private JTextField telephoneField;
	private JTextField nameField;
	private JTextField addressField;
	private JTextField serviceNameField;
	private JTextField salesRepIdField;
	private JTextField commissionField;
	private JTextField customerPathUrl;
	private JTable table;
	private JTextField callPathUrl;
	private JTextField ratesPathUrl;
	private JTextField customerBillTelephone;
	private JTextField customerBillYear;
	private JTextField customerBillMonth;
	private JTextField rateServiceName;
	private JTextField rateSourceCountry;
	private JTextField trafficMonth;
	private JTextField trafficYear;
	private JTextField trafficFilePath;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					AddSingleUser window = new AddSingleUser();
					window.frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the application.
	 */
	public AddSingleUser() {
		initialize();
	}

	/**
	 * Initialize the contents of the frame.
	 */
	private void initialize() {
		frame = new JFrame();
		frame.setBackground(new Color(176, 196, 222));
		frame.setBounds(100, 100, 1346, 687);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

		JButton btnAdduser = new JButton("Add Single Customer");
		btnAdduser.setBounds(446, 27, 213, 23);
		/* btnAdduser.setBackground(new Color(240, 240, 240)); */
		btnAdduser.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

					// Create and execute an SQL statement that returns some data.

					String SQL = "EXEC addSingleCustomer @telephone =" + telephoneField.getText() + ", @name = \""
							+ nameField.getText() + "\", @address = \"" + addressField.getText() + "\",@serviceName ="
							+ serviceNameField.getText() + ",@salesRepId =" + salesRepIdField.getText()
							+ ",@commission =" + commissionField.getText();
					stmt = con.createStatement();
					stmt.execute(SQL);

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}

			}

		});
		frame.getContentPane().setLayout(null);
		frame.getContentPane().add(btnAdduser);

		JButton btnAddCustomerTable = new JButton("Add Customer Table");
		btnAddCustomerTable.setBounds(446, 268, 213, 23);
		frame.getContentPane().add(btnAddCustomerTable);
		btnAddCustomerTable.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

//					FileChooser fc = new FileChooser();
//					File selectedFile = fc.showOpenDialog(null);
//					
//					if(selectedFile != null) {
//						customerPathUrl.setText(selectedFile.getAbsolutePath());
//					}

					// Create and execute an SQL statement that returns some data.
					String SQL = "EXEC addNewCustomers @filePath = \"" + customerPathUrl.getText() + "\"";
					stmt = con.createStatement();
					stmt.execute(SQL);

					/*
					 * String SQL2 = "SELECT * FROM customer"; PreparedStatement pst =
					 * con.prepareStatement(SQL2); rs = pst.executeQuery();
					 * table.setModel(DbUtils.resultSetToTableModel(rs));
					 */

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}

			}

		});

		telephoneField = new JTextField();
		telephoneField.setBounds(128, 27, 193, 22);
		frame.getContentPane().add(telephoneField);
		telephoneField.setColumns(10);

		JLabel lblTelephone = new JLabel("Telephone");
		lblTelephone.setBounds(10, 31, 114, 14);
		frame.getContentPane().add(lblTelephone);

		nameField = new JTextField();
		nameField.setBounds(128, 60, 193, 22);
		frame.getContentPane().add(nameField);
		nameField.setColumns(10);

		JLabel lblName = new JLabel("Name");
		lblName.setBounds(10, 64, 109, 14);
		frame.getContentPane().add(lblName);

		addressField = new JTextField();
		addressField.setBounds(128, 93, 193, 23);
		frame.getContentPane().add(addressField);
		addressField.setColumns(10);

		JLabel lblAddress = new JLabel("Address");
		lblAddress.setBounds(10, 97, 98, 14);
		frame.getContentPane().add(lblAddress);

		serviceNameField = new JTextField();
		serviceNameField.setBounds(128, 129, 193, 23);
		frame.getContentPane().add(serviceNameField);
		serviceNameField.setColumns(10);

		JLabel lblServicename = new JLabel("ServiceName");
		lblServicename.setBounds(10, 133, 109, 14);
		frame.getContentPane().add(lblServicename);

		salesRepIdField = new JTextField();
		salesRepIdField.setBounds(128, 163, 193, 23);
		frame.getContentPane().add(salesRepIdField);
		salesRepIdField.setColumns(10);

		JLabel lblSalesrepid = new JLabel("SalesRepId");
		lblSalesrepid.setBounds(10, 167, 132, 14);
		frame.getContentPane().add(lblSalesrepid);

		commissionField = new JTextField();
		commissionField.setBounds(128, 197, 193, 20);
		frame.getContentPane().add(commissionField);
		commissionField.setColumns(10);

		JLabel lblCommission = new JLabel("Commission");
		lblCommission.setBounds(10, 200, 98, 14);
		frame.getContentPane().add(lblCommission);

		customerPathUrl = new JTextField();
		customerPathUrl.setBounds(10, 269, 311, 20);
		frame.getContentPane().add(customerPathUrl);
		customerPathUrl.setColumns(10);

		JScrollPane scrollPane = new JScrollPane();
		scrollPane.setBounds(690, 27, 639, 351);
		frame.getContentPane().add(scrollPane);

		table = new JTable();
		scrollPane.setViewportView(table);

		JButton btnViewUpdatedCustomer = new JButton("View Updated Customer Table");
		btnViewUpdatedCustomer.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {

				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

					// Create and execute an SQL statement that returns some data.

					String SQL2 = "SELECT * FROM customer";
					PreparedStatement pst = con.prepareStatement(SQL2);
					ResultSet rs2 = pst.executeQuery();
					table.setModel(DbUtils.resultSetToTableModel(rs2));

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}

			}
		});
		btnViewUpdatedCustomer.setBounds(690, 389, 213, 23);
		frame.getContentPane().add(btnViewUpdatedCustomer);

		JLabel lblCurrentTable = new JLabel("CURRENT TABLE");
		lblCurrentTable.setBounds(688, 2, 114, 14);
		frame.getContentPane().add(lblCurrentTable);

		JButton btnBrowse = new JButton("Browse ...");
		btnBrowse.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {

				JFileChooser chooser = new JFileChooser();
				chooser.showOpenDialog(null);
				File f = chooser.getSelectedFile();
				String fileName = f.getAbsolutePath();
				customerPathUrl.setText(fileName);

			}
		});
		btnBrowse.setBounds(329, 268, 89, 23);
		frame.getContentPane().add(btnBrowse);

		callPathUrl = new JTextField();
		callPathUrl.setBounds(10, 300, 311, 20);
		frame.getContentPane().add(callPathUrl);
		callPathUrl.setColumns(10);

		JButton btnBrowse_1 = new JButton("Browse ..");
		btnBrowse_1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JFileChooser chooser = new JFileChooser();
				chooser.showOpenDialog(null);
				File f = chooser.getSelectedFile();
				String fileName = f.getAbsolutePath();
				callPathUrl.setText(fileName);
			}
		});
		btnBrowse_1.setBounds(329, 299, 89, 23);
		frame.getContentPane().add(btnBrowse_1);

		JButton btnAddCallDetails = new JButton("Add Call Details");
		btnAddCallDetails.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

//					FileChooser fc = new FileChooser();
//					File selectedFile = fc.showOpenDialog(null);
//					
//					if(selectedFile != null) {
//						customerPathUrl.setText(selectedFile.getAbsolutePath());
//					}

					// Create and execute an SQL statement that returns some data.
					String SQL = "EXEC addCallDetails @filePath = \"" + callPathUrl.getText() + "\"";
					stmt = con.createStatement();
					stmt.execute(SQL);

					/*
					 * String SQL2 = "SELECT * FROM customer"; PreparedStatement pst =
					 * con.prepareStatement(SQL2); rs = pst.executeQuery();
					 * table.setModel(DbUtils.resultSetToTableModel(rs));
					 */

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		btnAddCallDetails.setBounds(446, 299, 213, 23);
		frame.getContentPane().add(btnAddCallDetails);

		JButton btnViewUpdatedCall = new JButton("View Updated Call Table");
		btnViewUpdatedCall.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

					// Create and execute an SQL statement that returns some data.

					String SQL2 = "SELECT * FROM call";
					PreparedStatement pst = con.prepareStatement(SQL2);
					ResultSet rs2 = pst.executeQuery();
					table.setModel(DbUtils.resultSetToTableModel(rs2));

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		btnViewUpdatedCall.setBounds(690, 423, 213, 23);
		frame.getContentPane().add(btnViewUpdatedCall);

		ratesPathUrl = new JTextField();
		ratesPathUrl.setBounds(10, 331, 311, 20);
		frame.getContentPane().add(ratesPathUrl);
		ratesPathUrl.setColumns(10);

		JButton btnBrowse_2 = new JButton("Browse ...");
		btnBrowse_2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				JFileChooser chooser = new JFileChooser();
				chooser.showOpenDialog(null);
				File f = chooser.getSelectedFile();
				String fileName = f.getAbsolutePath();
				ratesPathUrl.setText(fileName);
			}
		});
		btnBrowse_2.setBounds(329, 330, 89, 23);
		frame.getContentPane().add(btnBrowse_2);

		JButton btnNewButton = new JButton("Add Rates");
		btnNewButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

//					FileChooser fc = new FileChooser();
//					File selectedFile = fc.showOpenDialog(null);
//					
//					if(selectedFile != null) {
//						customerPathUrl.setText(selectedFile.getAbsolutePath());
//					}

					// Create and execute an SQL statement that returns some data.
					String SQL = "EXEC updateRates @filePath = \"" + ratesPathUrl.getText() + "\"";
					stmt = con.createStatement();
					stmt.execute(SQL);

					/*
					 * String SQL2 = "SELECT * FROM customer"; PreparedStatement pst =
					 * con.prepareStatement(SQL2); rs = pst.executeQuery();
					 * table.setModel(DbUtils.resultSetToTableModel(rs));
					 */

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		btnNewButton.setBounds(446, 330, 213, 23);
		frame.getContentPane().add(btnNewButton);

		JButton btnViewUpdatedRates = new JButton("View Updated Rates Table");
		btnViewUpdatedRates.setForeground(new Color(0, 0, 0));
		btnViewUpdatedRates.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

					// Create and execute an SQL statement that returns some data.

					String SQL2 = "SELECT * FROM rate";
					PreparedStatement pst = con.prepareStatement(SQL2);
					ResultSet rs2 = pst.executeQuery();
					table.setModel(DbUtils.resultSetToTableModel(rs2));

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		btnViewUpdatedRates.setBounds(690, 457, 213, 23);
		frame.getContentPane().add(btnViewUpdatedRates);

		JLabel lblTelephone_1 = new JLabel("Telephone");
		lblTelephone_1.setBounds(10, 362, 63, 14);
		frame.getContentPane().add(lblTelephone_1);

		customerBillTelephone = new JTextField();
		customerBillTelephone.setBounds(128, 358, 193, 20);
		frame.getContentPane().add(customerBillTelephone);
		customerBillTelephone.setColumns(10);

		JLabel lblYear = new JLabel("Year");
		lblYear.setBounds(10, 393, 46, 14);
		frame.getContentPane().add(lblYear);

		customerBillYear = new JTextField();
		customerBillYear.setBounds(128, 390, 193, 20);
		frame.getContentPane().add(customerBillYear);
		customerBillYear.setColumns(10);

		JLabel lblMonth = new JLabel("Month");
		lblMonth.setBounds(10, 427, 46, 14);
		frame.getContentPane().add(lblMonth);

		customerBillMonth = new JTextField();
		customerBillMonth.setBounds(128, 421, 193, 20);
		frame.getContentPane().add(customerBillMonth);
		customerBillMonth.setColumns(10);

		JButton btnCreateCustomerBill = new JButton("Create Customer Bill");
		btnCreateCustomerBill.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

					// Create and execute an SQL statement that returns some data.

					String SQL = "EXEC createCustomerBill @telephone =" + customerBillTelephone.getText() + ", @year ="
							+ customerBillYear.getText() + ", @month =" + customerBillMonth.getText();
					/*
					 * stmt = con.createStatement(); stmt.execute(SQL);
					 */

					PreparedStatement pst = con.prepareStatement(SQL);
					rs = pst.executeQuery();
					table.setModel(DbUtils.resultSetToTableModel(rs));

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		btnCreateCustomerBill.setBounds(446, 358, 213, 23);
		frame.getContentPane().add(btnCreateCustomerBill);

		rateServiceName = new JTextField();
		rateServiceName.setBounds(128, 466, 193, 20);
		frame.getContentPane().add(rateServiceName);
		rateServiceName.setColumns(10);

		JLabel lblServicename_1 = new JLabel("ServiceName");
		lblServicename_1.setBounds(10, 466, 98, 14);
		frame.getContentPane().add(lblServicename_1);

		rateSourceCountry = new JTextField();
		rateSourceCountry.setBounds(128, 497, 193, 20);
		frame.getContentPane().add(rateSourceCountry);
		rateSourceCountry.setColumns(10);

		JLabel lblSourcecountry = new JLabel("SourceCountry");
		lblSourcecountry.setBounds(10, 499, 98, 14);
		frame.getContentPane().add(lblSourcecountry);

		JButton btnGetRateSheet = new JButton("Get Rate Sheet");
		btnGetRateSheet.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

					// Create and execute an SQL statement that returns some data.

					String SQL = "EXEC getRateSheet @serviceName =" + rateServiceName.getText() + ", @sourceCountry ="
							+ rateSourceCountry.getText();
					/*
					 * stmt = con.createStatement(); stmt.execute(SQL);
					 */

					PreparedStatement pst = con.prepareStatement(SQL);
					rs = pst.executeQuery();
					table.setModel(DbUtils.resultSetToTableModel(rs));

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}
			}
		});
		btnGetRateSheet.setBounds(446, 465, 213, 23);
		frame.getContentPane().add(btnGetRateSheet);

		JLabel lblMonth_1 = new JLabel("Month");
		lblMonth_1.setBounds(10, 570, 98, 14);
		frame.getContentPane().add(lblMonth_1);

		trafficMonth = new JTextField();
		trafficMonth.setBounds(128, 567, 193, 20);
		frame.getContentPane().add(trafficMonth);
		trafficMonth.setColumns(10);

		JLabel lblYear_1 = new JLabel("Year");
		lblYear_1.setBounds(10, 601, 89, 14);
		frame.getContentPane().add(lblYear_1);

		trafficYear = new JTextField();
		trafficYear.setBounds(128, 598, 193, 20);
		frame.getContentPane().add(trafficYear);
		trafficYear.setColumns(10);

		JLabel lblFilePath = new JLabel("File Path");
		lblFilePath.setBounds(10, 542, 109, 14);
		frame.getContentPane().add(lblFilePath);

		trafficFilePath = new JTextField();
		trafficFilePath.setBounds(128, 539, 193, 20);
		frame.getContentPane().add(trafficFilePath);
		trafficFilePath.setColumns(10);

		JButton btnGetMonthlyTrafficsummary = new JButton("Get Monthly TrafficSummary");
		btnGetMonthlyTrafficsummary.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				// Create a variable for the connection string.
				String connectionUrl = "jdbc:sqlserver://localhost:1433;"
						+ "databaseName=TelephoneCompany;integratedSecurity=true;";

				// Declare the JDBC objects.
				Connection con = null;
				Statement stmt = null;
				ResultSet rs = null;

				try {
					// Establish the connection.
					Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
					con = DriverManager.getConnection(connectionUrl);

					// Create and execute an SQL statement that returns some data.

					String SQL = "EXEC getMonthlyTrafficSummary @year =" + trafficYear.getText() + ", @month ="
							+ trafficMonth.getText() + ", @filePath =\"" + trafficFilePath.getText() + "\"";

					// stmt = con.createStatement();
					// stmt.execute(SQL);

					PreparedStatement pst = con.prepareStatement(SQL);
					rs = pst.executeQuery();
					table.setModel(DbUtils.resultSetToTableModel(rs));

				}

				// Handle any errors that may have occurred.
				catch (Exception e1) {
					e1.printStackTrace();
				}

			}
		});
		btnGetMonthlyTrafficsummary.setBounds(446, 538, 213, 23);
		frame.getContentPane().add(btnGetMonthlyTrafficsummary);

		JButton btnBrowse_3 = new JButton("Browse ...");
		btnBrowse_3.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {

				JFileChooser chooser = new JFileChooser();
				chooser.showOpenDialog(null);
				File f = chooser.getSelectedFile();
				String fileName = f.getAbsolutePath();
				trafficFilePath.setText(fileName);

			}
		});
		btnBrowse_3.setBounds(329, 538, 89, 23);
		frame.getContentPane().add(btnBrowse_3);
		
		JLabel lblToAddEntire = new JLabel("To Add Entire Tables From MsExcell Files Enter File Path");
		lblToAddEntire.setBounds(10, 244, 401, 14);
		frame.getContentPane().add(lblToAddEntire);

	}
}
