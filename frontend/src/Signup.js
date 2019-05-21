import React, { useState } from 'react';
import { Container, Col, Row, Form, Button } from 'react-bootstrap';
import { BACKEND_URL } from './consts.js';
import sha256 from 'sha-256-js';
import './Signup.css';
import $ from 'jquery';

const Signup = () => {
	const emailPattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$";
	const [state, setState] = useState({
		isValidated: false,
	});

	return (
		<Container>
			<Row className="justify-content-md-center">
				<Col xs="12" md="6">
					<h3>Sign up form</h3>
					<Form
						validated={ state.isValidated }
					>
						<Form.Group controlId="formSignupEmail" as={Row} className="Signup-row mt-4">
							<Form.Label column md="3">Email</Form.Label>
							<Col md="9">
								<Form.Control
									type="email"
									placeholder="Enter email"
									required pattern={ emailPattern }
								/>
								<Form.Control.Feedback type="invalid">Enter valid email</Form.Control.Feedback>
							</Col>
						</Form.Group>

						<Form.Group controlId="formSignupPassword" as={Row} className="Signup-row">
							<Form.Label column md="3">Password</Form.Label>
							<Col md="9">
								<Form.Control type="password" placeholder="Enter password" required />
								<Form.Control.Feedback type="invalid">Password is required field</Form.Control.Feedback>
							</Col>
						</Form.Group>

						<Form.Group controlId="formSignupFirstName" as={Row} className="Signup-row">
							<Form.Label column md="3">First name</Form.Label>
							<Col md="9">
								<Form.Control type="text" placeholder="Enter first name" required />
								<Form.Control.Feedback type="invalid">First name is required field</Form.Control.Feedback>
							</Col>
						</Form.Group>

						<Form.Group controlId="formSignupLastName" as={Row} className="Signup-row">
							<Form.Label column md="3">Last name</Form.Label>
							<Col md="9">
								<Form.Control type="text" placeholder="Enter last name" required />
								<Form.Control.Feedback type="invalid">Last name is required field</Form.Control.Feedback>
							</Col>
						</Form.Group>
					</Form>
					<p id="errorSignup" className="d-none text-danger">Signup error. Check email and password and try again.</p>
					<Button variant="info" onClick={ (e) => {
							$("#errorSignup").addClass("d-none").removeClass("d-block");
							const form = e.currentTarget;
							e.preventDefault();
							e.stopPropagation();
							setState({ ...state, isValidated: true });
							if (form.checkValidity() && $("input:invalid").length === 0) {
								const email = $("#formSignupEmail").val();
								const pass = $("#formSignupPassword").val();
								const firstName = $("#formSignupFirstName").val();
								const lastName = $("#formSignupLastName").val();
								$("#formSigninPassword").val("");
								const hash = sha256(pass);
								let formData = new FormData();
								formData.append("email", email);
								formData.append("password", hash);
								formData.append("first_name", firstName);
								formData.append("last_name", lastName);
								// // Add callback to real url (don't work with localhost)
								// formData.append("callback", window.location.href);
								fetch(BACKEND_URL + "/start_session.aspx", {
									credentials: "include",
									method: "POST",
									body: formData
									})
									.then(response => response.json())
									.then(json => {
										window.location.href = json.url;
										setState({ ...state, isValidated: false });
									})
									.catch(() => {
										setState({ ...state, isValidated: false });
								});
							}
							else
								setState({ ...state, isValidated: true });
						}
					}>
						Sign up
					</Button>
				</Col>
			</Row>
		</Container>
	);
}

export default Signup;