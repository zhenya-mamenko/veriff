import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Col, Form } from 'react-bootstrap';
import DateRangePicker from 'react-bootstrap-daterangepicker';
import Select from 'react-select';
import 'bootstrap-daterangepicker/daterangepicker.css';

const Search = ({ points, cols, onChange, dateFrom, dateTo, sameDropOff, fromPoint, toPoint }) => {
	const [state, setState] = useState({
		dateFrom: dateFrom ? dateFrom : new Date(),
		dateTo: dateTo ? dateTo : new Date(),
		sameDropOff: sameDropOff !== undefined ? sameDropOff : true,
		fromPoint: fromPoint ? fromPoint : 0,
		toPoint: toPoint ? toPoint : 0,
		now: new Date()
	});

	points = !points ? [] : points;
	return (
		<>
			<Col xs={12} md={ state.sameDropOff ? 24 / cols : 12 / cols }>
				<Form.Check 
					type="checkbox"
					id="drop-off"
					label="Same drop-off"
					checked={ state.sameDropOff }
					onChange={ () => setState({ ...state,
						sameDropOff: !state.sameDropOff,
						toPoint: !state.sameDropOff ? state.fromPoint : state.toPoint
						})
					}
				/>
				<Select
					className="basic-single"
					placeholder="Select city or airport..."
					isSearchable={true}
					isClearable={true}
					isLoading={points.length === 0}
					name="pointFrom"
					options={ points.map(x => { return {value: x.pointId, label: x.city} } )}
					value={
						points.length === 0 || state.fromPoint === 0 ? null :
							points.filter(x => x.pointId === state.fromPoint).map(x => { return {value: x.pointId, label: x.city} })
					}
					onChange={ value => {
						const newState = {
							...state,
							fromPoint: value ? value.value : 0,
							toPoint: state.sameDropOff ? (value ? value.value : 0) : state.toPoint
						};
						setState(newState);
						if (onChange)
							onChange(!value || value.value === 0 || (!state.sameDropOff && state.toPoint === 0), newState);
						}
					}
				/>
			</Col>
			<Col xs={12} md={ 12 / cols } className={ "pt-4 " + (state.sameDropOff ? "d-none" : "d-block") }>
				<Select
					className="basic-single"
					placeholder="To?"
					isSearchable={true}
					isClearable={true}
					isLoading={points.length === 0}
					name="pointTo"
					options={ points.map(x => { return {value: x.pointId, label: x.city} } )}
					value={
						points.length === 0 || state.toPoint === 0 ? null :
							points.filter(x => x.pointId === state.toPoint).map(x => { return {value: x.pointId, label: x.city} })
					}
					onChange={ value => {
						const newState = { ...state, toPoint: value ? value.value : 0 };
						setState(newState);
						if (onChange)
							onChange(!value || value.value === 0 || state.fromPoint === 0, newState);
						}
					}
				/>
			</Col>
			<Col xs={12} md={ 12 / cols } className="pt-4">
				<DateRangePicker onApply={
						(e, picker) => {
							const newState = { ...state, dateFrom: new Date(picker.startDate), dateTo: new Date(picker.endDate) };
							setState(newState);
							if (onChange)
								onChange(state.fromPoint === 0 || state.toPoint === 0, newState);
						}
					}
					minDate = { state.now }
					startDate = { state.dateFrom }
					endDate = { state.dateTo }
					containerClass="w-100"
					autoApply={true}
				>
					<input
						type="text"
						className="form-control"
						onChange={() => {}}
						value={ `${state.dateFrom.toDateString()} — ${state.dateTo.toDateString()}` }
					/>
				</DateRangePicker>
			</Col>
		</>
	);
}

Search.propTypes = {
	points: PropTypes.array.isRequired,
	cols: PropTypes.number.isRequired,
	onChange: PropTypes.func,
	dateFrom: PropTypes.objectOf(Date),
	dateTo: PropTypes.objectOf(Date),
	sameDropOff: PropTypes.bool,
	fromPoint: PropTypes.number,
	toPoint: PropTypes.number
};

export default Search;