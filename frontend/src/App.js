import React, { useState, lazy, Suspense } from 'react';
import { BACKEND_URL } from './consts.js';
import { Container, Navbar, Spinner } from 'react-bootstrap';
import logo from './logo.png';
import UserStatus from './UserStatus';
import Home from './Home';

const Results = lazy(() => import('./Results'));

const App = () => {
	const [state, setState] = useState({
		points: [],
		dateFrom: new Date(),
		dateTo: new Date(),
		sameDropOff: true,
		fromPoint: 0,
		toPoint: 0,
		page: 0,
		isLogged: false
	});

	if (state.points.length === 0) {
		fetch(BACKEND_URL + "/get_points.aspx")
			.then(response => response.json())
			.then(json => {
				setState({ ...state, points: json });
			})
	}

	const handleClick = (data) => {
		const { dateFrom, dateTo, sameDropOff, fromPoint, toPoint } = data;
		setState({ ...state, page: 1, dateFrom, dateTo, sameDropOff, fromPoint, toPoint });
	}

	const handleUserStatus = (data) => {
		const { isLogged } = data;
		setState({ ...state, isLogged });
	}

	const handleRentClick = (data) => {
		console.log(state.isLogged, data)
		if (!state.isLogged)
			return;
		const fields = [ "carId", "price", "fromPoint", "toPoint", "dateFrom", "dateTo" ];
		let formData = new FormData();
		for (let i = 0; i < fields.length; i++)
			formData.append(fields[i], data[fields[i]]);
		fetch(BACKEND_URL + "/rent.aspx", {
			method: "POST",
			body: formData,
			credentials: "include"
			})
			.then(() => {
				setState({ ...state, page: 2 });
			})
	}

	return (
		<>
			<Navbar expand="md" variant="dark" bg="info" className="mb-3">
				<Container>
					<Navbar.Brand href="/">
						<img
							src={logo}
							width="32"
							height="32"
							className="d-inline-block align-top"
							alt=""
						/>
						{' Rent a Car'}
					</Navbar.Brand>
					<Navbar.Toggle />
					<Navbar.Collapse className="justify-content-end">
						<UserStatus onChange={ handleUserStatus } />
					</Navbar.Collapse>
				</Container>
			</Navbar>

			{
				state.page === 0 &&
				<Home points={ state.points } onButtonClick={ handleClick } />
			}
			{
				state.page === 1 &&
				<Suspense fallback={ <Container className="text-center"><Spinner animation="border" role="status" size="sm" /> Loading...</Container> }>
					<Results { ...state } onRentClick={ handleRentClick } />
				</Suspense>
				
			}

		</>
	);
}

export default App;
