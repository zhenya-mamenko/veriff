import React, { useState } from 'react';
import PropTypes from 'prop-types';
import { Col, Form } from 'react-bootstrap';
import DateRangePicker from 'react-bootstrap-daterangepicker';
import Select from 'react-select';
import 'bootstrap-daterangepicker/daterangepicker.css';

const Search = ({ points, cols, onChange }) => {
	const [state, setState] = useState({
		dateFrom: new Date(),
		dateTo: new Date(),
		sameDropOff: true,
		fromPoint: 0,
		toPoint: 0,
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
						setState({
							...state,
							fromPoint: value ? value.value : 0,
							toPoint: state.sameDropOff ? (value ? value.value : 0) : state.toPoint
							});
						if (onChange)
							onChange(!value || value.value === 0 || (!state.sameDropOff && state.toPoint === 0));
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
						setState({ ...state, toPoint: value ? value.value : 0 });
						if (onChange)
							onChange(!value || value.value === 0 || state.fromPoint === 0);
						}
					}
				/>
			</Col>
			<Col xs={12} md={ 12 / cols } className="pt-4">
				<DateRangePicker onApply={
					(e, picker) => setState({ ...state, dateFrom: new Date(picker.startDate), dateTo: new Date(picker.endDate) })
					}
					minDate = { state.now }
					startDate = { state.dateFrom }
					endDate = { state.dateTo }
					containerClass="w-100"
					autoApply={true}
				>
					<input type="text" className="form-control" onChange={()=>{}} value={ `${state.dateFrom.toDateString()} — ${state.dateTo.toDateString()}` } />
				</DateRangePicker>
			</Col>
		</>
	);
}

Search.propTypes = {
	points: PropTypes.array.isRequired,
	cols: PropTypes.number.isRequired,
	onChange: PropTypes.func
};

export default Search;